//
//  AlbumManager.swift
//  photo-club
//
//  Created by Morris Richman on 3/15/25.
//

import Foundation
import SwiftUI
#if SKIP
import SkipFirebaseFirestore
import SkipFirebaseStorage
import SkipFirebaseAuth
#else
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
#endif

struct Photo: Identifiable, Hashable {
    let id: String
    let url: URL
    let image: UIImage?
    let createdAt: Date
}

struct Album: Identifiable, Codable {
    let id: String
    let ownerID: String
    let name: String
    let startDate: Date
    let endDate: Date
    let thumbnailURL: URL?
    let code: String
    
    var subtitle: String {
        "\(startDate.formatted(date: .numeric, time: .shortened)) – \(endDate.formatted(date: .numeric, time: .shortened))"
    }
}

final class AlbumManager: ObservableObject {
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    private var albumCodes: [String] {
        get {
            (UserDefaults.standard.string(forKey: "albumCodesData") ?? "").components(separatedBy: ",")
        }
        set {
            UserDefaults.standard.set(newValue.joined(separator: ","), forKey: "albumCodesData")
        }
    }
    @Published private(set) var albums: [Album] = []
    
    func joinAlbum(code: String) async throws {
        albumCodes.append(code)
        
        try await getAlbums()
    }
    
    func leaveAlbum(code: String) {
        albumCodes.removeAll { $0 == code }
        albums.removeAll { $0.code == code }
    }
    
    func getAlbums() async throws {
        guard !albumCodes.isEmpty else { return }
        
        var albums: [Album] = []
        
        let firebaseAlbums = try await db.collection("Albums").whereField("code", in: albumCodes.map({ $0 as Any })).getDocuments()
        for album in firebaseAlbums.documents {
            guard let name = album.get("name") as? String,
                  let code = album.get("code") as? String,
                  let ownerID = album.get("ownerID") as? String,
                  let startDate = album.get("startDate") as? Timestamp,
                  let endDate = album.get("endDate") as? Timestamp
            else {
                continue
            }
            
            let albumData: Album = .init(
                id: album.documentID,
                ownerID: ownerID,
                name: name,
                startDate: startDate.dateValue(),
                endDate: endDate.dateValue(),
                thumbnailURL: URL(string: album.get("thumbnailURL") as? String ?? ""),
                code: code
            )
                albums.append(albumData)
        }
    
        await MainActor.run { [albums] in
            self.albums = albums
        }
    }
    
    @Published var photoProgress: CGFloat = 0
    func getPhotos(for album: Album, addPhoto: @escaping (Photo) -> Void) async throws {
        defer {
            DispatchQueue.main.async {
                self.photoProgress = 0
            }
        }
        let firebaseAlbum = db.collection("Albums").document(album.id)
        let firebasePhotos = try await firebaseAlbum.collection("Images").order(by: "createdAt", descending: true).getDocuments()
        
        for (i, document) in firebasePhotos.documents.enumerated() {
            guard let urlString = document.get("url") as? String, let url = URL(string: urlString), let date = document.get("createdAt") as? Timestamp else { continue }
            
            let (imageData, _) = try await URLSession.shared.data(from: url)
            
            await MainActor.run {
                photoProgress = CGFloat(i+1)/CGFloat(firebasePhotos.count)
            }
            addPhoto(Photo(id: document.documentID, url: url, image: UIImage(data: imageData), createdAt: date.dateValue()))
        }
    }
    
    func getPhotos(for album: Album) async throws -> [Photo] {
        var photos: [Photo] = []
        
        try await getPhotos(for: album, addPhoto: { photos.append($0) })
        
        return photos
    }
    
    func createAlbum(withName name: String, startDate: Date, endDate: Date, thumbnail: URL?, for user: User) async throws {
        let albumId = UUID().uuidString
        let startTimestamp = Timestamp(date: startDate)
        let endTimestamp = Timestamp(date: endDate)
        let code = randomString(length: 4)
        var data: [String: Any] = ["name": name, "ownerID": user.uid, "startDate": startTimestamp, "endDate": endTimestamp, "code": code]
        
        if let thumbnail {
            let imageRef = storage.child("images/\(albumId)/thumbnail.\(thumbnail.pathExtension)")
            let _ = try await imageRef.putFileAsync(from: thumbnail)
            let thumbnailURL = try await imageRef.downloadURL()
            data["thumbnailURL"] = thumbnailURL.absoluteString
        }
        
        try await db.collection("Albums").document(albumId).setData(data)
        
        try await joinAlbum(code: code)
    }
    
    func addPhoto(toAlbum album: Album, imageURL: URL) async throws -> Photo {
        let photoId = UUID().uuidString
        let imageRef = storage.child("images/\(album.id)/\(photoId).\(imageURL.pathExtension)")
        #if SKIP
        let _ = try await imageRef.putFileAsync(from: imageURL)
        #else
        let _ = try await imageRef.putFileAsync(from: imageURL) { progress in
            guard let progress else { return }
            DispatchQueue.main.async {
                self.photoProgress = Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
            }
        }
        #endif
        let downloadURL = try await imageRef.downloadURL()
        
        try await db.collection("Albums").document(album.id).collection("Images").document(photoId).setData(["url": downloadURL.absoluteString, "createdAt": Timestamp(date: .now)])
        return Photo(id: photoId, url: imageURL, image: UIImage(data: (try? Data(contentsOf: imageURL)) ?? Data()), createdAt: Date())
    }
    
    func deletePhoto(fromAlbum album: Album, photo: Photo, for user: User) async throws {
        guard album.ownerID == user.uid else {
            return
        }
        
        try await db.collection("Albums").document(album.id).collection("Images").document(photo.id).delete()
        let imageRef = storage.child("images/\(album.id)/\(photo.id).\(photo.url.pathExtension)")
        try await imageRef.delete()
    }
    
    private func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
      }
}

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
#else
import FirebaseFirestore
#endif

struct Photo: Identifiable, Codable, Hashable {
    let id: String
    let url: URL
    let createdAt: Date
}

struct Album: Identifiable, Codable {
    let id: String
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
    private var albumCodes: [String] {
        get {
            (UserDefaults.standard.string(forKey: "albumCodesData") ?? "").components(separatedBy: ",")
        }
        set {
            UserDefaults.standard.set(newValue.joined(separator: ","), forKey: "albumCodesData")
        }
    }
    @Published private(set) var albums: [Album] = []
    
    func joinAlbum(code: String) {
        albumCodes.append(code)
        
        Task {
            try? await getAlbums()
        }
    }
    
    func leaveAlbum(code: String) {
        albumCodes.removeAll { $0 == code }
        albums.removeAll { $0.code == code }
    }
    
    func getAlbums() async throws {
        guard !albumCodes.isEmpty else { return }
        
        let albums = try await db.collection("Albums").whereField("code", in: albumCodes.map({ $0 as Any })).getDocuments()
        for album in albums.documents {
            guard let name = album.get("name") as? String,
                  let code = album.get("code") as? String,
                  let startDate = album.get("startDate") as? Timestamp,
                  let endDate = album.get("endDate") as? Timestamp
            else {
                continue
            }
            
            let albumData: Album = .init(
                id: album.documentID,
                name: name,
                startDate: startDate.dateValue(),
                endDate: endDate.dateValue(),
                thumbnailURL: URL(string: album.get("thumbnailURL") as? String ?? ""),
                code: code
            )
            await MainActor.run {
                self.albums.append(albumData)
            }
        }
    }
    
    func getPhotos(for album: Album) async throws -> [Photo] {
        let firebaseAlbum = db.collection("Albums").document(album.id)
        let firebasePhotos = try await firebaseAlbum.collection("Images").getDocuments()
        
        let photos: [Photo] = firebasePhotos.documents.compactMap { snapshot in
            guard let urlString = snapshot.get("url") as? String, let url = URL(string: urlString), let date = snapshot.get("createdAt") as? Timestamp else { return nil }
            
            return Photo(id: snapshot.documentID, url: url, createdAt: date.dateValue())
        }
        return photos
    }
    
    func createAlbum(withName name: String) async throws {
        
    }
    
    func addPhoto(toAlbum: Album, image: UIImage) async throws {
        
    }
}

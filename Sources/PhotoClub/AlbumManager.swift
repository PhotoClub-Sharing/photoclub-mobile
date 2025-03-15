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
    let ownerName: String
    let thumbnailURL: URL?
    let code: String
}

final class AlbumManager: ObservableObject {
    private let db = Firestore.firestore()
//    @AppStorage("albumCodesData") var _albumCodes: String?
    private var albumCodes: [String] {
        get {
            do {
                guard let directoryURL = Bundle.main.resourceURL,
                let fileURL = URL(string: "\(directoryURL.absoluteString)/albumCodes.json")//.appending(path: "albumCodes.json")
                else {
                    return [String]()
                }
                
                let data = try Data(contentsOf: fileURL)
                let array = try JSONDecoder().decode([String].self, from: data)
                return array
            } catch {
                print(error)
                return [String]()
            }
        }
        set {
            do {
                guard let directoryURL = Bundle.main.resourceURL,
                let fileURL = URL(string: "\(directoryURL.absoluteString)/albumCodes.json")
                else {
                    return
                }
                let data = try JSONEncoder().encode(newValue)
                try data.write(to: fileURL)
            } catch {
                print(error)
            }
        }
    }
    @Published private(set) var albums: [Album] = []
    
    func addAlbum(code: String) {
        albumCodes.append(code)
    }
    
    func getAlbums() async throws {
        guard !albumCodes.isEmpty else { return }
        
        let albums = try await db.collection("Albums").whereField("code", in: albumCodes.map({ $0 as Any })).getDocuments()
        for album in albums.documents {
            guard let name = album.get("name") as? String,
                  let ownerName = album.get("ownerName") as? String,
                  let code = album.get("code") as? String
            else {
                continue
            }
            
            let albumData: Album = .init(
                id: album.documentID,
                name: name,
                ownerName: ownerName,
                thumbnailURL: nil,
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

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
    @AppStorage("albumCodesData") var _albumCodes: Data?
    private var albumCodes: [String] {
        get {
            (try? JSONDecoder().decode(Array<String>.self, from: _albumCodes ?? Data())) ?? []
        }
        set {
            _albumCodes = try? JSONEncoder().encode(newValue)
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
            guard let urlString = snapshot.get("url") as? String, let url = URL(string: urlString), let date = snapshot.get("createdAt") as? Date else { return nil }
            
            return Photo(id: snapshot.documentID, url: url, createdAt: date)
        }
        return photos
    }
}

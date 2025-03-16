//
//  AlbumsView.swift
//  photo-club
//
//  Created by Morris Richman on 3/15/25.
//

import SwiftUI

struct AlbumsView: View {
    @EnvironmentObject var albumManager: AlbumManager
    var body: some View {
        NavigationStack {
            List {
                ForEach(albumManager.albums) { album in
                    NavigationLink {
                        AlbumDetailsView(album: album)
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(album.name)
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(album.ownerName)
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Albums")
            .toolbar {
                Button {
                    albumManager.addAlbum(code: "hello")
                } label: {
                    Label("Add Album", systemImage: "plus.circle")
                        .labelStyle(.iconOnly)
                }
                .foregroundStyle(Color.actionColor)
            }
        }
        .tint(Color.actionColor)
        .task {
            try? await albumManager.getAlbums()
        }
    }
}

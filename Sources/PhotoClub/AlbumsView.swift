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
                        EmptyView()
                    } label: {
                        HStack {
                            VStack {
                                Text(album.name)
                                    .font(.headline)
                                Text(album.ownerName)
                                    .foregroundStyle(.secondary)
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
                    Label {
                        Text("Add Album")
                    } icon: {
                        Image("plus.circle", bundle: .module)
                    }

                }
            }
        }
        .task {
            try? await albumManager.getAlbums()
        }
    }
}

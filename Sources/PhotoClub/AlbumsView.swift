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
                            if let url = album.thumbnailURL {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                            VStack(alignment: .leading) {
                                Text(album.name)
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(album.subtitle)
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
            }
//            .scrollContentBackground(.hidden)
//            .background(Color.logoBackground.ignoresSafeArea())
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

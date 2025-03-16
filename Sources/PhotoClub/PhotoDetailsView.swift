//
//  PhotoDetailsView.swift
//  photo-club
//
//  Created by Morris Richman on 3/15/25.
//

import SwiftUI

struct PhotoDetailsView: View {
    let album: Album
    @Binding var photos: [Photo]
    @State var selectedPhoto: Photo
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var albumManager: AlbumManager
    
    var body: some View {
        TabView(selection: $selectedPhoto) {
            ForEach(photos) { photo in
                Group {
                    if let image = photo.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    } else {
                        AsyncImage(url: photo.url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .tag(photo)
                #if !SKIP
                .zoomable(minZoomScale: 0.5, doubleTapZoomScale: 2)
                #endif
            }
        }
        #if !SKIP
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        #endif
        .tabViewStyle(.page(indexDisplayMode: photos.count > 1 ? .always : .never))
        .overlay(alignment: .topTrailing) {
            Button {
                dismiss()
            } label: {
                Label("Close", systemImage: "xmark")
                    .labelStyle(.iconOnly)
            }
            .clipShape(Circle())
            .padding(8)
            #if SKIP
            .background(Color.secondarySystemBackground, in: Circle())
            #else
            .background(.thinMaterial, in: Circle())
            #endif
            .padding([.top, .trailing])
        }
        .overlay(alignment: .topLeading) {
            Button(role: .destructive) {
                Task {
                    let photo = selectedPhoto
                    try? await albumManager.deletePhoto(fromAlbum: album, photo: photo)
                    if selectedPhoto == photo {
                        if photos.count > 1, let index = photos.firstIndex(where: { $0.id == photo.id }) {
                            if index == 0 {
                                self.selectedPhoto = photos[max(index + 1, 0)]
                            } else {
                                self.selectedPhoto = photos[max(index - 1, 0)]
                            }
                        } else {
                            dismiss()
                        }
                    }
                    self.photos.removeAll(where: { $0.id == photo.id })
                }
            } label: {
                Label("Delete", systemImage: "trash")
                    .labelStyle(.iconOnly)
            }
            .clipShape(Circle())
            .padding(8)
            #if SKIP
            .background(Color.secondarySystemBackground, in: Circle())
            #else
            .background(.thinMaterial, in: Circle())
            #endif
            .padding([.top, .leading])
        }
    }
}

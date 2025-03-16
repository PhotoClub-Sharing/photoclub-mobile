//
//  PhotoDetailsView.swift
//  photo-club
//
//  Created by Morris Richman on 3/15/25.
//

import SwiftUI

struct PhotoDetailsView: View {
    let photos: [Photo]
    @State var selectedPhoto: Photo
    @Environment(\.dismiss) var dismiss
    
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
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: photos.count > 1 ? .always : .never))
        #endif
        .tabViewStyle(.page(indexDisplayMode: .always))
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
    }
}

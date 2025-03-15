//
//  AsyncImage.swift
//  photo-club
//
//  Created by Morris Richman on 3/15/25.
//

import SkipUI
import Foundation

struct AsyncImage<Content: View>: View {
    let url: URL?
    let content: (Image) -> Content
    
    var body: some View {
        SkipUI.AsyncImage(url: url) { image in
            content(image)
        } placeholder: {
            ProgressView()
        }
    }
}

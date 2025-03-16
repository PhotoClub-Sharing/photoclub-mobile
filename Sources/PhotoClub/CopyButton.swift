//
//  CopyButton.swift
//  photo-club
//
//  Created by Morris Richman on 3/15/25.
//

import SwiftUI

struct CopyButton: View {
    @State var isCopied = false
    let text: String
    
    var systemImage: String {
        #if SKIP
        isCopied ? "checkmark" : "clipboard"
        #else
        isCopied ? "checkmark" : "document.on.clipboard"
        #endif
    }
    
    var body: some View {
        Button {
            isCopied = true
            UIPasteboard.general.string = text
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                isCopied = false
            })
        } label: {
            Label {
                Text("Copy \(text)")
            } icon: {
                Image(systemName: systemImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
            }
                .labelStyle(.iconOnly)
                .animation(.default, value: isCopied)
        }
    }
}

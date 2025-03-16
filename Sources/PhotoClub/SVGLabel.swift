//
//  SVGLabel.swift
//  photo-club
//
//  Created by Morris Richman on 3/15/25.
//

import SwiftUI

struct SVGLabel<Icon: SVGIcon>: View {
    let title: LocalizedStringKey
    let icon: Icon
    let tintColor: Color?
    
    public init(_ title: LocalizedStringKey, tintColor: Color? = nil, icon: Icon) {
        self.title = title
        self.tintColor = tintColor
        self.icon = icon
    }
    
    public init(_ title: LocalizedStringKey, tintColor: Color?, @ViewBuilder icon: () -> Icon) {
        self.title = title
        self.tintColor = tintColor
        self.icon = icon()
    }
    
    var body: some View {
        Label {
            Text(title)
        } icon: {
            icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
        }
        .tint(tintColor)
    }
}

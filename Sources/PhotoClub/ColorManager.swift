//
//  ColorManager.swift
//  photo-club
//
//  Created by Morris Richman on 3/15/25.
//

import Foundation
import SwiftUI

extension Color {
//    /// A function that dynamically updates the color based on `userInterfaceStyle`
//    static func dynamicColor(light: UIColor, dark: UIColor) -> Color {
//        let uiColor = UIColor { $0.userInterfaceStyle == UIUserInterfaceStyle.light ? light : dark }
//        
//        return Color(uiColor: uiColor)
//    }
//    
//    /// A function that dynamically updates the color based on `userInterfaceStyle`
//    static func dynamicColor(light: Color, dark: Color) -> Color {
//        dynamicColor(light: UIColor(light), dark: UIColor(dark))
//    }
    
    // MARK: Custom Colors
    // Because Skip doesn't support ColorSets
    
    static var logoBackground: Self {
        Color(#colorLiteral(red: 1, green: 0.738301754, blue: 0.3153707385, alpha: 1))
    }
    static var actionColor: Self {
        Color(#colorLiteral(red: 0.9803921569, green: 0.4509803922, blue: 0.2588235294, alpha: 1))
    }
    
    #if SKIP
    static let secondarySystemBackground = Color.gray.opacity(0.1)
    #else
    static let secondarySystemBackground = Color(uiColor: .secondarySystemBackground)
    #endif
}

//
//  SettingsView.swift
//  photo-club
//
//  Created by Morris Richman on 3/16/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button("Sign Out", role: .destructive) {
            Task {
                dismiss()
                try? await authManager.signOut()
            }
        }
    }
}

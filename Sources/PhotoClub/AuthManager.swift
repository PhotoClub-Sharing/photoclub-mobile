//
//  AuthManager.swift
//  photo-club
//
//  Created by Morris Richman on 3/15/25.
//

import Foundation
import SwiftUI
#if SKIP
import SkipFirebaseAuth
#else
import FirebaseAuth
#endif

final class AuthManager: ObservableObject {
    @Published private var auth = Auth.auth()
    var currentUser: User? {
        auth.currentUser
    }
    var isAuthenticated: Bool {
        currentUser != nil
    }
    
    func signUp(email: String, password: String) async throws {
        try await auth.createUser(withEmail: email, password: password)
    }
    
    func signIn(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }
    
    func signInAnnonymously() async throws {
        try await auth.signInAnonymously()
    }
    
    func resetPassword(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }
    
    func signOut() async throws {
        try auth.signOut()
    }
}

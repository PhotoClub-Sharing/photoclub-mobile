import SwiftUI
import UIKit

public struct AuthView: View {
    @EnvironmentObject private var authManager: AuthManager
    @State var email: String = ""
    @State var password: String = ""
    @State var password2: String = ""
    
    @State var isSigningUp: Bool = true

    public var body: some View {
        VStack(spacing: 40) {
            Image("logo", bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: .infinity, alignment: .center)
            
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                if isSigningUp {
                    SecureField("Confirm Password", text: $password2)
                        .textFieldStyle(.roundedBorder)
                    
                    if password != password2 {
                        Text("Passwords Do Not Match")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    
                    Button {
                        Task {
                            try? await authManager.signUp(email: email, password: password)
                        }
                    } label: {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(password2 != password || email.isEmpty || password.isEmpty)
                    
                    Button {
                        isSigningUp = false
                    } label: {
                        Text("Already have an account? Sign In")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                } else {
                    Button {
                        Task {
                            try? await authManager.signIn(email: email, password: password)
                        }
                    } label: {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(email.isEmpty || password.isEmpty)
                    
                    Button {
                        isSigningUp = false
                    } label: {
                        Text("Don't have an account? Sign Up")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                
                Button("Continue as Guest") {
                    Task {
                        try? await authManager.signInAnnonymously()
                    }
                }
                    .foregroundStyle(Color.primary)
            }
            .padding(.horizontal, 30)
            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
            .background(
                UnevenRoundedRectangle(topLeadingRadius: 25, topTrailingRadius: 25)
                    .fill(Color.white)
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
        .background(Color.logoBackground.ignoresSafeArea())
    }
}

import SwiftUI
import UIKit

public struct AuthView: View {
    @EnvironmentObject private var authManager: AuthManager
    @State var email: String = ""
    @State var password: String = ""
    @State var password2: String = ""
    @State var isShowErrorAlert: Bool = false
    @State var errorAlertMessage: String = ""
    
    @State var isSigningUp: Bool = true
    
    func showError(message: String) {
        isShowErrorAlert = true
        errorAlertMessage = message
    }
    
    func signUp() {
        Task {
            do {
                try await authManager.signUp(email: email, password: password)
            } catch {
                print(error)
                showError(message: error.localizedDescription)
            }
        }
    }
    
    func signIn() {
        Task {
            do {
                try await authManager.signIn(email: email, password: password)
            } catch {
                print(error)
                showError(message: error.localizedDescription)
            }
        }
    }
    
    func signInAnnonymously() {
        Task {
            do {
                try await authManager.signInAnnonymously()
            } catch {
                print(error)
                showError(message: error.localizedDescription)
            }
        }
    }

    public var body: some View {
        VStack(spacing: 40) {
            Image("logo", bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: .infinity, alignment: .center)
            
            VStack {
                Text("Sign In / Sign Up")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
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
                    
                    Button(action: signUp) {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.actionColor)
                    .disabled(password2 != password || email.isEmpty || password.isEmpty)
                    
                    Button {
                        isSigningUp = false
                    } label: {
                        Text("Already have an account? Sign In")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.actionColor)
                } else {
                    Button(action: signIn) {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.actionColor)
                    .disabled(email.isEmpty || password.isEmpty)
                    
                    Button {
                        isSigningUp = true
                    } label: {
                        Text("Don't have an account? Sign Up")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.actionColor)
                    
                }
                
                Button(action: signInAnnonymously) {
                    Text("Continue as Guest")
                        .frame(maxWidth: .infinity)
                }
                    .foregroundStyle(Color.primary)
            }
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .padding(.horizontal, 30)
            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
            .background(
                UnevenRoundedRectangle(topLeadingRadius: 55, topTrailingRadius: 55)
                    .fill(Color.white)
            )
        }
        .animation(.default, value: isSigningUp)
        .alert("Uh Oh", isPresented: $isShowErrorAlert, actions: {
            Button("ok") {}
        }, message: {
            Text(errorAlertMessage)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
        .background(Color.logoBackground.ignoresSafeArea())
    }
}

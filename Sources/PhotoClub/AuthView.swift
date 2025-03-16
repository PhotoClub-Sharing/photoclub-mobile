import SwiftUI
import UIKit

public struct AuthView: View {
    @EnvironmentObject private var authManager: AuthManager

    public var body: some View {
        VStack(spacing: 40) {
            Image("logo", bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: .infinity, alignment: .center)
            
            VStack {
                Button {
                    
                } label: {
                    SVGLabel("Continue with Apple", tintColor: .white, icon: AppleLogo())
                    .frame(maxWidth: .infinity)
                }
                .tint(Color.actionColor)
                .buttonStyle(.borderedProminent)
                Button {
                    
                } label: {
                    SVGLabel("Continue with Google", tintColor: .white, icon: GoogleLogo())
                    .frame(maxWidth: .infinity)
                }
                .tint(Color.actionColor)
                .buttonStyle(.borderedProminent)
                
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

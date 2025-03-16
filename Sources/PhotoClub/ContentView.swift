import SwiftUI
import UIKit

public struct ContentView: View {
    @State var appearance = ""

    public init() {
    }

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

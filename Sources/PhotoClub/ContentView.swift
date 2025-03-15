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
                    Label {
                        Text("Continue with Apple")
                    } icon: {
                        AppleLogo()
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                    }
                    .frame(maxWidth: .infinity)
                }
                .tint(Color.actionColor)
                .buttonStyle(.borderedProminent)
                Button {
                    
                } label: {
                    Label {
                        Text("Continue with Google")
                    } icon: {
                        GoogleLogo()
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                    }
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

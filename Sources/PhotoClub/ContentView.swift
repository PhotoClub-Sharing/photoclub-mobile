import SwiftUI
import UIKit

public struct ContentView: View {
    @State var appearance = ""

    public init() {
    }

    public var body: some View {
        VStack(spacing: 40) {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: .infinity, alignment: .center)
            
            VStack {
                    Button {
                        
                    } label: {
                        Label {
                            Text("Continue with Apple")
                        } icon: {
                            Image("Apple_logo_black", bundle: .module)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 25)
                        }
                    }
                    .foregroundStyle(Color.accentColor)
                        .buttonStyle(.borderedProminent)
                    Button("Continue with Google") {}
                        .buttonStyle(.borderedProminent)
                
                Button("Continue as Guest") {}
            }
            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
            .background(
                UnevenRoundedRectangle(topLeadingRadius: 25, topTrailingRadius: 25)
                    .fill(Color.white)
            )
        }
        .tint(Color.accentColor)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
        .background(Color.logoBackground.ignoresSafeArea())
    }
}

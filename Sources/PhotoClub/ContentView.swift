import SwiftUI


public struct ContentView: View {
    @State var appearance = ""

    public init() {
    }

    public var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
            VStack {
                HStack {
                    Button("Apple") {}
                        .buttonStyle(.borderedProminent)
                    Button("Google") {}
                        .buttonStyle(.borderedProminent)
                }
                
                Button("Continue as Guest") {}
                    .foregroundStyle(.white)
            }
        }
        .background(Color("LogoBackground"))
    }
}

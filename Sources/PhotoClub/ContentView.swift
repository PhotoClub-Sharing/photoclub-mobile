import SwiftUI


public struct ContentView: View {
    @State var appearance = ""

    public init() {
    }

    public var body: some View {
        VStack {
            Image("logo")
            VStack {
                Button("Apple") {}
                Button("Google") {}
                
                Button("Continue as Guest") {}
            }
        }
    }
}

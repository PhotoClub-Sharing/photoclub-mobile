import SwiftUI
import SkipKit

struct ListView: View {
//    @State private var selectedItems: [PhotosPickerItem] = [] // Array to store selected images
    @State private var selectedImages: [UIImage] = [] // Array to store final selected images
    @State private var isShowingPhotoPicker = false
    @State private var selectedImageURL: URL?
    
    
    var body: some View {
        VStack(alignment: .leading) {
            // Logo, Title, and Subtitle
            HStack {
                Image("logo", bundle: .module)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 100) // Adjusted height to fit the logo better
                
                VStack(alignment: .leading) {
                    Text("Album")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("LOREM!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)

            ScrollView {
                VStack(spacing: 16) {
                    // Show selected images
                    ForEach(selectedImages, id: \.self) { image in
                        Image(uiImage: image) // Display selected image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 150)
                            .clipped()
                            .cornerRadius(10)
                    }
                }
                .padding()

                // Button to add image
                Button("Add Photos") {
                    isShowingPhotoPicker = true
                }
                .frame(maxWidth: .infinity)
                .tint(Color.actionColor)
                .buttonStyle(.borderedProminent)
                
                
            }
        }
        .background(Color.logoBackground.ignoresSafeArea())
//        .padding(.top, -30)  // Removed extra padding at the top of the screen
        .withMediaPicker(type: .library, isPresented: $isShowingPhotoPicker, selectedImageURL: $selectedImageURL)
    
        .onChange(of: selectedImageURL) { _, newValue in
            guard let newValue else { return }
            
            do {
                defer {
                    self.selectedImageURL = nil
                }
                let data = try Data(contentsOf: newValue)
                guard let image = UIImage(data: data) else {
                    return
                }
                selectedImages.append(image)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    ListView()
}

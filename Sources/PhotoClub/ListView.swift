import SwiftUI
import PhotosUI

struct ListView: View {
    @State private var selectedItems: [PhotosPickerItem] = [] // Array to store selected images
    @State private var selectedImages: [UIImage] = [] // Array to store final selected images
    
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
                PhotosPicker(selection: $selectedItems, matching: .images, photoLibrary: .shared()) {
                    HStack {
                        Image(systemName: "plus.circle.fill") // Plus icon for the button
                            .font(.title)
                            .foregroundColor(.white)
                        
                        Text("Add Photo")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                 
                }
                
                
                .onChange(of: selectedItems) { newItems in
                    // Load the selected images
                    Task {
                        for item in newItems {
                            // Retrieve selected image
                            if let data = try? await item.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                selectedImages.append(uiImage)
                            }
                        }
                    }
                }
                
                
            }
        }
        .background(Color.logoBackground.ignoresSafeArea())
        .padding(.top, -30) // Removed extra padding at the top of the screen
    }
}

#Preview {
    ListView()
}

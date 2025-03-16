import SwiftUI
import SkipKit

struct AlbumDetailsView: View {
    let album: Album
    @EnvironmentObject var albumManager: AlbumManager
//    @State private var selectedItems: [PhotosPickerItem] = [] // Array to store selected images
    @State private var selectedImages: [UIImage] = [] // Array to store final selected images
    @State private var photos: [Photo] = [] // Array to store final selected images
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
                    ForEach(photos, id: \.self) { photo in
                        AsyncImage(url: photo.url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 150)
                                .clipped()
                                .cornerRadius(10)
                        } placeholder: {
                            ProgressView()
                        }

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
        .task {
            do {
                self.photos = try await albumManager.getPhotos(for: album)
            } catch {
                print(error)
            }
        }
//        .background(Color.logoBackground.ignoresSafeArea())
//        .padding(.top, -30)  // Removed extra padding at the top of the screen
        .withMediaPicker(type: .library, isPresented: $isShowingPhotoPicker, selectedImageURL: $selectedImageURL, detents: [.large])
    
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

//#Preview {
//    AlbumDetailsView()
//}

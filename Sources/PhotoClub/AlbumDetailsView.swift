import SwiftUI
import SkipKit

struct AlbumDetailsView: View {
    let album: Album
    @EnvironmentObject var albumManager: AlbumManager
    @State private var photos: [Photo] = [] // Array to store final selected images
    @State private var isShowingPhotoPicker = false
    @State private var selectedImageURL: URL?
    @State private var isShowingPhotosLoadingIndicator: Bool = false
    #if !SKIP
    @Namespace var namespace
    #endif
    @State var photoDetailSheetItem: Photo?
    
    let columns = Array(repeating: GridItem(.flexible(minimum: 50)), count: 2)
    
    var body: some View {
        ScrollView {
            #if SKIP
            photosLoadingIndicator
            #endif
            LazyVGrid(columns: columns, alignment: .center) {
                Button {
                    isShowingPhotoPicker = true
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.secondarySystemBackground)
                        .frame(height: 150)
                        .overlay {
                            Label {
                                Text("Add Photo")
                            } icon: {
                                Image(systemName: "plus")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                            }
                                .labelStyle(.iconOnly)
                        }

                }
                ForEach(photos, id: \.self) { photo in
                    if #available(iOS 18.0, *) {
                        Button {
                            photoDetailSheetItem = photo
                        } label: {
                            PhotoCell(photo: photo)
                        }
#if !SKIP
                        .matchedTransitionSource(id: photo.id, in: namespace)
#endif
                    } else {
                        Button {
                            photoDetailSheetItem = photo
                        } label: {
                            PhotoCell(photo: photo)
                        }
                    }
                }
            }
            .padding()
        }
        #if !SKIP
        .safeAreaInset(edge: .top, content: {
            photosLoadingIndicator
        })
        #endif
        .navigationTitle(album.name)
        .fullScreenCover(item: $photoDetailSheetItem, content: { photo in
            if #available(iOS 18.0, *) {
                PhotoDetailsView(photos: photos, selectedPhoto: photo)
#if !SKIP
                    .navigationTransition(.zoom(sourceID: photo.id, in: namespace))
#endif
            } else {
                PhotoDetailsView(photos: photos, selectedPhoto: photo)
            }
        })
        .refreshable {
            self.photos.removeAll()
            await fetchPhotos()
        }
        .task {
            await fetchPhotos()
        }
//        .background(Color.logoBackground.ignoresSafeArea())
//        .padding(.top, -30)  // Removed extra padding at the top of the screen
        .withMediaPicker(type: .library, isPresented: $isShowingPhotoPicker, selectedImageURL: $selectedImageURL, detents: [.large])
    
        .onChange(of: selectedImageURL) { _, newValue in
            guard let newValue else { return }
            
            Task {
                do {
                    defer {
                        self.selectedImageURL = nil
                        #if !SKIP
                        self.isShowingPhotosLoadingIndicator = false
                        #endif
                    }
                    #if !SKIP
                    self.isShowingPhotosLoadingIndicator = true
                    #endif
                    let photo = try await albumManager.addPhoto(toAlbum: album, imageURL: newValue)
                    self.photos.insert(photo, at: 0)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func fetchPhotos() async {
        do {
            self.isShowingPhotosLoadingIndicator = true
            defer {
                self.isShowingPhotosLoadingIndicator = false
                
            }
            try await albumManager.getPhotos(for: album) { photo in
                self.photos.append(photo)
            }
        } catch {
            print(error)
        }
    }
    
    @ViewBuilder
    var photosLoadingIndicator: some View {
        if isShowingPhotosLoadingIndicator {
            ProgressView(value: albumManager.photoProgress, total: 1)
                .animation(.default, value: albumManager.photoProgress)
        }
    }
}

struct PhotoCell: View {
    let photo: Photo
    var body: some View {
        Rectangle()
            .aspectRatio(1, contentMode: .fill)
            .overlay {
                if let image = photo.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    AsyncImage(url: photo.url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
            .frame(height: 150)
            .clipped()
            .cornerRadius(10)
    }
}

//#Preview {
//    AlbumDetailsView()
//}

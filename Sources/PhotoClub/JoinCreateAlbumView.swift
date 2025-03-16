//
//  JoinCreateAlbumView.swift
//  photo-club
//
//  Created by Morris Richman on 3/15/25.
//

import SwiftUI

struct JoinCreateAlbumView: View {
    @EnvironmentObject var albumManager: AlbumManager
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    
    @State var code: String = ""
    @State var joinIsLoading = false
    
    @State var name: String = ""
    @State var startDate: Date = .now
    @State var endDate: Date = .now.addingTimeInterval(60 * 60 * 24)
    @State var createIsLoading = false
    
    @State var thumbnail: UIImage?
    @State var thumbnailURL: URL?
    @State var isShowingPhotoPicker = false
    
    @State var isShowingSignIn = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack {
                        Text("Join Album")
                            .font(.title2)
                        Divider()
                        TextField("Enter Code", text: $code)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .textFieldStyle(.roundedBorder)
                        Button {
                            Task {
                                do {
                                    joinIsLoading = true
                                    defer { joinIsLoading = false }
                                    try await albumManager.joinAlbum(code: code)
                                    dismiss()
                                } catch {
                                    print(error)
                                }
                            }
                        } label: {
                            HStack {
                                if joinIsLoading {
                                    ProgressView()
                                } else {
                                    Text("Join Album")
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .animation(.bouncy, value: joinIsLoading)
                        .buttonStyle(.borderedProminent)
                        .disabled(code.isEmpty)
                    }
                    .padding(12)
                    .background(Color.secondarySystemBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    
                    Divider()
                    
                    VStack {
                        Text("Create Album")
                            .font(.title2)
                        Divider()
                        TextField("Name", text: $name)
                            .textFieldStyle(.roundedBorder)
                        
                        DatePicker("Start Date", selection: $startDate)
                        DatePicker("End Date", selection: $endDate)
                        VStack {
                            if let thumbnail {
                                Image(uiImage: thumbnail)
                                    .resizable()
                                    .scaledToFit()
                                //                            .frame(width: 50, height: 50)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            Button {
                                isShowingPhotoPicker = true
                            } label: {
                                Text(thumbnail == nil ? "Select Thumbnail" : "Change Thumbnail")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                        }
                        .withMediaPicker(type: .library, isPresented: $isShowingPhotoPicker, selectedImageURL: $thumbnailURL, detents: [.large])
                        .onChange(of: thumbnailURL) { _, newValue in
                            guard let newValue else {
                                self.thumbnail = nil
                                return
                            }
                            
                            do {
                                let data = try Data(contentsOf: newValue)
                                guard let image = UIImage(data: data) else { return }
                                self.thumbnail = image
                            } catch {
                                print(error)
                            }
                        }
                        Group {
                            if authManager.isGuest {
                                Button {
                                    isShowingSignIn = true
                                } label: {
                                    Text("Sign In")
                                        .frame(maxWidth: .infinity)
                                }
                            } else {
                                Button {
                                    Task {
                                        do {
                                            createIsLoading = true
                                            defer { createIsLoading = false }
                                            try await albumManager.createAlbum(withName: name, startDate: startDate, endDate: endDate, thumbnail: thumbnailURL)
                                            dismiss()
                                        } catch {
                                            print(error)
                                        }
                                    }
                                } label: {
                                    HStack {
                                        if createIsLoading {
                                            ProgressView()
                                        } else {
                                            Text("Create Album")
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .animation(.bouncy, value: createIsLoading)
                        .buttonStyle(.borderedProminent)
                        .disabled(name.isEmpty)
                    }
                    .padding(12)
                    .background(Color.secondarySystemBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .padding()
            }
            .sheet(isPresented: $isShowingSignIn) {
                AuthView()
            }
            .toolbar {
                #if !SKIP
                Button {
                    dismiss()
                } label: {
                    Label("Close", systemImage: "xmark")
                        .labelStyle(.iconOnly)
                        .padding(8)
                        .background(Color.secondarySystemBackground, in: Circle())
                }
                .clipShape(Circle())
                #endif
            }
        }
    }
}

#Preview {
    JoinCreateAlbumView()
}

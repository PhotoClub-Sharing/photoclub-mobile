//
//  JoinCreateAlbumView.swift
//  photo-club
//
//  Created by Morris Richman on 3/15/25.
//

import SwiftUI

struct JoinCreateAlbumView: View {
    @EnvironmentObject var albumManager: AlbumManager
    @Environment(\.dismiss) var dismiss
    
    @State var code: String = ""
    @State var joinIsLoading = false
    
    @State var name: String = ""
    @State var startDate: Date = .now
    @State var endDate: Date = .now.addingTimeInterval(60 * 60 * 24)
    @State var createIsLoading = false
    
    var body: some View {
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
                    if joinIsLoading {
                        ProgressView()
                    } else {
                        Text("Join Album")
                    }
                }
                .animation(.bouncy, value: joinIsLoading)
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
                Button {
                    Task {
                        do {
                            createIsLoading = true
                            defer { createIsLoading = false }
                            try await albumManager.createAlbum(withName: name, startDate: startDate, endDate: endDate)
                            dismiss()
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    if createIsLoading {
                        ProgressView()
                    } else {
                        Text("Create Album")
                    }
                }
                .animation(.bouncy, value: createIsLoading)
            }
            .padding(12)
            .background(Color.secondarySystemBackground)
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .padding()
    }
}

#Preview {
    JoinCreateAlbumView()
}

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
    @State var name: String = ""
    @State var startDate: Date = .now
    @State var endDate: Date = .now.addingTimeInterval(60 * 60 * 24)
    
    var body: some View {
        
        VStack {
            VStack {
                Text("Join Album")
                    .font(.title2)
                Divider()
                TextField("Enter Code", text: $code)
                    .textFieldStyle(.roundedBorder)
                Button("Join Album") {
                    albumManager.joinAlbum(code: code)
                }
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

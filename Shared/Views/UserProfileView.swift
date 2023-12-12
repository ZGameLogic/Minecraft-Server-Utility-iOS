//
//  UserProfileView.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/12/23.
//

import SwiftUI

struct UserProfileView: View {
    @AppStorage("id") private var user_id = ""
    @Binding var user: MSUUser
    @Binding var isShowing: Bool
    
    var body: some View {
        ScrollView {
            AsyncImage(url: URL(string: "https://cdn.discordapp.com/avatars/\(user.id)/\(user.avatar).png")){ phase in
                switch phase {
                case .empty:
                    ProgressView().frame(width: 200, height: 200)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .cornerRadius(100)
                case .failure:
                    Text("Failed to load image")
                @unknown default:
                    Text("Failed to load image")
                }
            }.padding()
            Text(user.username)
            Button(action: {
                isShowing = false
                user = MSUUser()
                user_id = ""
            }, label: {Text("Logout")})
        }
    }
}

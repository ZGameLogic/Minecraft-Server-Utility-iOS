//
//  UserProfileView.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/12/23.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject private var user: User
    @Binding var isShowing: Bool
    
    var body: some View {
        ScrollView {
            CachedImage(url: "https://cdn.discordapp.com/avatars/\(user.id)/\(user.avatar).png")
                .frame(width: 200, height: 200)
                .cornerRadius(100)
                .padding()
            Text(user.username)
                .font(.title)
                .scaledToFit()
            Button(action: {
                isShowing = false
                user.logout()
            }, label: {
                Text("Logout")
            }).buttonStyle(.borderedProminent)
                .tint(.danger)
                .padding()
        }
    }
}

#Preview {
    UserProfileView(
        isShowing: Binding.constant(true)
    )
}

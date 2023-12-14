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
                        .padding()
                case .failure:
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding()
                @unknown default:
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding()
                }
            }.padding()
            Text(user.username)
                .font(.title)
                .scaledToFit()
            Button(action: {
                isShowing = false
                user = MSUUser()
                user_id = ""
            }, label: {
                Text("Logout")
            }).buttonStyle(.borderedProminent)
                .tint(.danger)
                .padding()
        }.onAppear(){
            print(user.avatar)
        }
    }
}

#Preview {
    UserProfileView(
        user: Binding.constant(MSUUser(
            username: "zabory",
            id: "232675572772372481",
            avatar: "5c2791cbabc9b54b2c852d1dc2bb820b",
            loggedIn: true
        )),
        isShowing: Binding.constant(true)
    )
}

//
//  ContentView.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 10/3/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoginPresented = false
    @State private var isProfilePresented = false
    @State private var user = MSUUser()
    @AppStorage("id") private var user_id = ""
    
    var body: some View {
        NavigationStack {
            TabView {
                ServersGeneralView().tabItem({
                    Label("Monitors", systemImage: "chart.bar.doc.horizontal")
                })
            }.toolbar {
                ToolbarItem {
                    if(!user.loggedIn){
                        Button(action: {
                            isLoginPresented.toggle()
                        }) {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding()
                        }
                    } else {
                        Button(action: {
                            isProfilePresented.toggle()
                        }) {
                            AsyncImage(url: URL(string: "https://cdn.discordapp.com/avatars/\(user.id)/\(user.avatar).png")){ phase in
                                switch phase {
                                case .empty:
                                    ProgressView().frame(width: 40, height: 40)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .cornerRadius(20)
                                case .failure:
                                    Text("Failed to load image")
                                @unknown default:
                                    Text("Failed to load image")
                                }
                            }
                        }.padding()
                    }
                }
            }.sheet(isPresented: $isLoginPresented, content: {LoginView(presented: $isLoginPresented, user: $user)})
                .sheet(isPresented: $isProfilePresented, content: {UserProfileView(user: $user, isShowing: $isProfilePresented)})
            .onAppear(){
                if(!user_id.isEmpty){
                    Task {
                        let user = try await MSUService.login(id: user_id)
                        if let user = user {
                            user_id = user.id
                            self.user = user
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

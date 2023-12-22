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
    @State private var isCreateServerPresented = false
    @EnvironmentObject private var user: User
    
    var body: some View {
        NavigationView {
            TabView {
                ServersGeneralView().tabItem({
                    Label("Servers", systemImage: "chart.bar.doc.horizontal")
                })
            }.navigationTitle("Servers")
                .toolbar {
                if(user.hasPermission(server: "General Permissions", permission: "C")){
                    ToolbarItem {
                        Button(action: {
                            isCreateServerPresented = true
                        }, label: {
                            Label("Add Server", systemImage: "note.text.badge.plus")
                        })
                    }
                }
                ToolbarItem {
                    if(!user.loggedIn){
                        Button(action: {
                            isLoginPresented.toggle()
                        }) {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding([.top, .trailing, .bottom])
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
                        }.padding([.top, .trailing, .bottom])
                    }
                }
            }
                .sheet(isPresented: $isLoginPresented){LoginView(presented: $isLoginPresented)}
                .sheet(isPresented: $isProfilePresented){UserProfileView(isShowing: $isProfilePresented)}
                .sheet(isPresented: $isCreateServerPresented){AddServerView(isPresented: $isCreateServerPresented)}
            .onAppear(){
                if(!user.id.isEmpty && !user.loggedIn){
                    Task {
                        let user = try await MSUService.login(id: user.id)
                        if let user = user {
                            self.user.update(user: user)
                            print(user)
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

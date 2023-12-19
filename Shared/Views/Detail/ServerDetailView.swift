//
//  ServerDetailView.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/14/23.
//

import SwiftUI

struct ServerDetailView: View {
    @EnvironmentObject private var user: User
    @ObservedObject var server: MinecraftServer
    
    var body: some View {
        ScrollView {
            HStack {
                Circle()
                    .fill(server.statusFill())
                    .frame(width: 20, height: 20)
                Text(server.name)
                    .font(.title)
                    .padding()
            }
            Section(content: {
                ForEach(server.online, id: \.self) { player in
                    HStack {
                        URLImage(width: 20, height: 20, url: "https://mc-heads.net/avatar/\(player)/20")
                            .padding([.leading])
                        Text(player).padding([.leading], 5)
                        Spacer()
                    }
                }
            }, header: {
                HStack {
                    Text("Players - \(server.playersOnline)")
                        .font(.title2)
                        .padding()
                    Spacer()
                }
            })
            if(user.hasPermission(server: server.name, permission: "s")){
                Section(content: {
                    ControlGroup {
                        Button("Start"){
                            sendCommand(command: "start")
                        }.disabled(!(server.status == "Offline"))
                        Button("Stop"){
                            sendCommand(command: "stop")
                        }.disabled(!(server.status == "Online"))
                    }.padding([.leading, .trailing])
                }, header: {
                    HStack {
                        Text("Administration")
                            .font(.title2)
                            .padding()
                        Spacer()
                    }
                })
            }
        }
    }
    
    func sendCommand(command: String){
        server.sendMessageFunction!(server.name, command, [:])
    }
}

#Preview {
    ServerDetailView(server: MinecraftServer(
        name: "ATM9",
        status: "Starting",
        online: ["zabory"]
    )).environmentObject(User(
        permissions: ["General Permissions": "A"], 
        loggedIn: true
    ))
}

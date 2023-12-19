//
//  ServerListView.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/14/23.
//

import SwiftUI

struct ServerListView: View {
    @ObservedObject var server: MinecraftServer
    
    var body: some View {
        VStack {
            Spacer()
            HStack{
                Circle()
                    .fill(server.statusFill())
                    .frame(width: 20, height: 20)
                Text(server.name)
                    .font(.title)
                    .padding([.leading], 10)
                Spacer()
            }
            HStack{
                Text("Online: \(server.playersOnline)")
                    .padding([.horizontal], 10)
                Spacer()
                VStack {
                    Text(server.serverConfig.version)
                        .padding([.horizontal], 10)
                }
            }
            ForEach(server.online, id: \.self) { player in
                HStack {
                    URLImage(width: 20, height: 20, url: "https://mc-heads.net/avatar/\(player)/20")
                        .padding([.leading])
                    Text(player).padding([.leading], 5)
                    Spacer()
                }
            }
            Spacer()
        }
    }
}

#Preview {
    ServerListView(server: MinecraftServer(
        name: "Test",
        status: "Online",
        online: ["zabory"],
        serverConfig: MinecraftServerConfig(
            version: "1.20.4",
            category: "vanilla"
        )
    ))
}

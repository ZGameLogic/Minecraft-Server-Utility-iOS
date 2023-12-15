//
//  ServersGeneralView.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/12/23.
//

import SwiftUI

struct ServersGeneralView: View {
    @StateObject var servers = MinecraftServersViewModel();
    
    var body: some View {
        List {
            ForEach(servers.minecraftServers) { server in
                NavigationLink(destination:  ServerDetailView(server: server)) {
                    ServerListView(server: server)
                }
            }
        }.refreshable {
            servers.refreshSevers()
        }
    }
}

#Preview {
    ServersGeneralView(servers: MinecraftServersViewModel(minecraftServers: [
        MinecraftServer(name: "Bens", status: "Offline", serverConfig: MinecraftServerConfig(
            version: "1.20.4",
            category: "vanilla"
        )),
        MinecraftServer(name: "ATM9", status: "Online", serverConfig: MinecraftServerConfig(
            version: "All The Mods 9 ATM9",
            category: "ServerFiles-0.2.21"
        ),
        playersOnline: 2)
    ]))
}

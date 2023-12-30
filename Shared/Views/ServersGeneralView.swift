//
//  ServersGeneralView.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/12/23.
//

import SwiftUI

struct ServersGeneralView: View {
    @EnvironmentObject var servers: MinecraftServersViewModel
    
    var body: some View {
        if servers.minecraftServers.isEmpty {
            ServersUnavailableView(refresh: servers.refreshSevers)
                .navigationTitle("Servers")
        } else {
            List {
                ForEach(servers.minecraftServers) { server in
                    NavigationLink(destination:  ServerDetailView(server: server)) {
                        ServerListView(server: server)
                    }
                }
            }.navigationTitle("Servers")
            .refreshable {
                servers.refreshSevers()
            }
        }
    }
}

#Preview {
    ServersGeneralView()
        .environmentObject(MinecraftServersViewModel(minecraftServers: [
            MinecraftServer(name: "Bens", status: "Offline", serverConfig: MinecraftServerConfig(
                version: "1.20.4",
                category: "vanilla"
            )),
            MinecraftServer(name: "ATM9", status: "Online", serverConfig: MinecraftServerConfig(
                version: "ServerFiles-0.2.21",
                category: "All the mods 9"
            ))
        ]))
}

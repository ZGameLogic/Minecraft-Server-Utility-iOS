//
//  ServerListView.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/14/23.
//

import SwiftUI

struct ServerListView: View {
    var server: MinecraftServer
    
    var body: some View {
        VStack {
            Spacer()
            HStack{
                Circle()
                    .fill(statusFill())
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
            Spacer()
        }
    }
    
    func statusFill() -> Color {
        switch server.status {
        case "Online":
            return .online
        case "Offline":
            return .offline
        case "Crashed":
            return .crashed
        case "Updating":
            return .updating
        case "Starting", "Stopping":
            return .transitioning
        default:
            return .crashed
        }
    }
}

#Preview {
    ServerListView(server: MinecraftServer(
        name: "Test",
        status: "Online",
        serverConfig: MinecraftServerConfig(
            version: "1.20.4",
            category: "vanilla"
        )
    ))
}

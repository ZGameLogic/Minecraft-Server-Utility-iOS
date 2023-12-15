//
//  MinecraftServerViewModel.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/14/23.
//

import Foundation


class MinecraftServersViewModel: ObservableObject {
    @Published var minecraftServers: [MinecraftServer]
    private var webSocketTask: URLSessionWebSocketTask?
    
    init(minecraftServers: [MinecraftServer] = []) {
        self.minecraftServers = minecraftServers
        refreshSevers()
        openWebSocket()
    }
    
    func refreshSevers(){
        Task {
            do {
                let servers = try await MSUService.fectchServers()
                
                DispatchQueue.main.async {
                    self.minecraftServers = servers
                }
            } catch {
                print(error)
            }
        }
    }
    
    private func openWebSocket() {
        let url = URL(string: "\(Constants.WEBSOCKET_URL)")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        receiveMessages()
        webSocketTask?.resume()
    }
    
    private func receiveMessages() {
        Task {
            while let message = try? await webSocketTask?.receive() {
                if case .string(let text) = message {
                    print(text)
                }
            }
        }
    }
}

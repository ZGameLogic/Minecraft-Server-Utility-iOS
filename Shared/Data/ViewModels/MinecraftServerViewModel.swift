//
//  MinecraftServerViewModel.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/14/23.
//

import Foundation

class MinecraftServersViewModel: ObservableObject, SwiftStompDelegate {
    @Published var minecraftServers: [MinecraftServer] = []
    private var swiftStomp: SwiftStomp
    
    init(minecraftServers: [MinecraftServer] = []) {
        let urlString = "\(Constants.API_BASE_URL)/ws"
        self.minecraftServers = minecraftServers
        swiftStomp = SwiftStomp(host: URL(string: urlString)!)
        swiftStomp.delegate = self
        swiftStomp.autoReconnect = true
        refreshSevers()
    }
    
    func refreshSevers(){
        Task {
            do {
                let servers = try await MSUService.fectchServers()
                DispatchQueue.main.async {
                    self.minecraftServers = servers
                }
                self.swiftStomp.connect(autoReconnect: true)
            } catch {
                print(error)
            }
        }
    }
    
    func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
        print("Websocket connected")
        for minecraftServer in minecraftServers {
            swiftStomp.subscribe(to: "/server/\(minecraftServer.name)")
        }
    }
    
    func onDisconnect(swiftStomp: SwiftStomp, disconnectType: StompDisconnectType) {
        
    }
    
    func onMessageReceived(swiftStomp: SwiftStomp, message: Any?, messageId: String, destination: String, headers: [String : String]) {
        guard let data = message as? String else {
            return
        }
        guard let stompFrame = try? JSONDecoder().decode(StompMessageFrame.self, from: data.data(using: .utf8)!) else {
            return
        }
        // TODO: process stomp frame
    }
    
    func onReceipt(swiftStomp: SwiftStomp, receiptId: String) {
        
    }
    
    func onError(swiftStomp: SwiftStomp, briefDescription: String, fullDescription: String?, receiptId: String?, type: StompErrorType) {
        
    }
    
    func onSocketEvent(eventName: String, description: String) {
        
    }
}

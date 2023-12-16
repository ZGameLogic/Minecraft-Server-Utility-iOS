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
        let urlString = "http://localhost:8080/ws"
        
        self.swiftStomp = SwiftStomp(host: URL(string: urlString)!) //< Create instance
        self.swiftStomp.delegate = self //< Set delegate
        self.swiftStomp.autoReconnect = true //< Auto reconnect on error or cancel

        self.swiftStomp.connect() //< Connect
        refreshSevers()
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
    
    func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
        print("Websocket connected")
    }
    
    func onDisconnect(swiftStomp: SwiftStomp, disconnectType: StompDisconnectType) {
        
    }
    
    func onMessageReceived(swiftStomp: SwiftStomp, message: Any?, messageId: String, destination: String, headers: [String : String]) {
        print(message!)
    }
    
    func onReceipt(swiftStomp: SwiftStomp, receiptId: String) {
        
    }
    
    func onError(swiftStomp: SwiftStomp, briefDescription: String, fullDescription: String?, receiptId: String?, type: StompErrorType) {
        print(briefDescription)
    }
    
    func onSocketEvent(eventName: String, description: String) {
        
    }
}

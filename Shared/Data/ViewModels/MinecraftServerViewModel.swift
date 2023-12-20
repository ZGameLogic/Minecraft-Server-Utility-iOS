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
        refreshSevers()
    }
    
    func sendMessage(server: String, action: String, data: [String: String]){
        let uid: String = UserDefaults.standard.value(forKey: "id") as! String
        let message = WebsocketMessage(action: action, userId: uid, data: data)
        let url = "/app/server/\(server)"
        swiftStomp.send(body: message, to: url)
    }
    
    func refreshSevers(){
        Task {
            do {
                let servers = try await MSUService.fectchServers()
                DispatchQueue.main.async {
                    self.minecraftServers = servers
                    if(!self.swiftStomp.isConnected){
                        self.swiftStomp.connect(autoReconnect: true)
                    }
                    for server in self.minecraftServers {
                        server.sendMessageFunction = self.sendMessage
                    }
                        
                }
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
        guard let data = message as? String else { return }
        guard let stompFrame = try? JSONDecoder().decode(StompMessageFrame.self, from: data.data(using: .utf8)!) else { return }
        guard let index = minecraftServers.firstIndex(where: {$0.name == stompFrame.server}) else { return }
        switch(stompFrame.messageType){
        case "status":
            guard let statusFrame = try? JSONDecoder().decode(GeneralMessage.self, from: data.data(using: .utf8)!) else { return }
            minecraftServers[index].status = statusFrame.message
            break
        case "log":
            guard let statusFrame = try? JSONDecoder().decode(GeneralMessage.self, from: data.data(using: .utf8)!) else { return }
            // TODO: Add to log
            break
        case "player":
            guard let statusFrame = try? JSONDecoder().decode(PlayersMessage.self, from: data.data(using: .utf8)!) else { return }
            minecraftServers[index].online = statusFrame.players
            break
        default:
            break
        }
    }
    
    func onReceipt(swiftStomp: SwiftStomp, receiptId: String) {
        
    }
    
    func onError(swiftStomp: SwiftStomp, briefDescription: String, fullDescription: String?, receiptId: String?, type: StompErrorType) {
        
    }
    
    func onSocketEvent(eventName: String, description: String) {
        
    }
}

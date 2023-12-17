//
//  MinecraftServer.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/7/23.
//

import Foundation

class MinecraftServer: Codable, Identifiable {
    var id: String
    
    let filePath: String
    let status: String
    let name: String
    let serverProperties: [String: String]
    let serverConfig: MinecraftServerConfig
    let online: [String]
    let playersOnline: Int
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.filePath = try container.decode(String.self, forKey: .filePath)
        self.status = try container.decode(String.self, forKey: .status)
        self.name = try container.decode(String.self, forKey: .name)
        self.serverProperties = try container.decode([String : String].self, forKey: .serverProperties)
        self.serverConfig = try container.decode(MinecraftServerConfig.self, forKey: .serverConfig)
        self.online = try container.decode([String].self, forKey: .online)
        self.playersOnline = try container.decode(Int.self, forKey: .playersOnline)
        id = name
    }
    
    init(
        name: String = "",
        filePath: String = "",
        status: String = "",
        serverProperties: [String:String] = [:],
        online: [String] = [],
        serverConfig: MinecraftServerConfig = MinecraftServerConfig(),
        playersOnline: Int = 0
    ) {
        self.name = name
        self.filePath = filePath
        self.status = status
        self.serverProperties = serverProperties
        self.serverConfig = serverConfig
        self.online = online
        self.playersOnline = playersOnline
        id = name
    }
    
    static func == (lhs: MinecraftServer, rhs: MinecraftServer) -> Bool {
        lhs.name == rhs.name &&
        lhs.filePath == rhs.filePath &&
        lhs.status == rhs.status &&
        lhs.id == rhs.id &&
        lhs.serverProperties == rhs.serverProperties &&
        lhs.online == rhs.online &&
        lhs.playersOnline == rhs.playersOnline &&
        lhs.serverConfig == rhs.serverConfig
    }
}


class MinecraftServerConfig: Codable {
    let autoStart: Bool
    let autoUpdate: Bool
    let version: String
    let category: String
    let startCommand: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.autoStart = try container.decode(Bool.self, forKey: .autoStart)
        self.autoUpdate = try container.decode(Bool.self, forKey: .autoUpdate)
        self.version = try container.decode(String.self, forKey: .version)
        self.category = try container.decode(String.self, forKey: .category)
        self.startCommand = try container.decode(String.self, forKey: .startCommand)
    }
    
    init(
        autoStart: Bool = false,
        autoUpdate: Bool = false,
        version: String = "",
        category: String = "",
        startCommand: String  = ""
    ){
        self.autoStart = autoStart
        self.autoUpdate = autoUpdate
        self.version = version
        self.category = category
        self.startCommand = startCommand
    }
    
    static func == (lhs: MinecraftServerConfig, rhs: MinecraftServerConfig) -> Bool {
        lhs.autoStart == rhs.autoStart &&
        lhs.autoUpdate == rhs.autoUpdate &&
        lhs.version == rhs.version &&
        lhs.category == rhs.category &&
        lhs.startCommand == rhs.startCommand
    }
}

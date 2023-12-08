//
//  MinecraftServer.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/7/23.
//

import Foundation

struct MinecraftServer: Codable {
    let filePath: String
    let status: String
    let name: String
    let serverProperties: [String: String]
    let serverConfig: MinecraftServerConfig
    let online: [String]
    let playersOnline: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.filePath = try container.decode(String.self, forKey: .filePath)
        self.status = try container.decode(String.self, forKey: .status)
        self.name = try container.decode(String.self, forKey: .name)
        self.serverProperties = try container.decode([String : String].self, forKey: .serverProperties)
        self.serverConfig = try container.decode(MinecraftServerConfig.self, forKey: .serverConfig)
        self.online = try container.decode([String].self, forKey: .online)
        self.playersOnline = try container.decode(Int.self, forKey: .playersOnline)
    }
    
    init() {
        filePath = ""
        status = ""
        name = ""
        serverProperties = [:]
        serverConfig = MinecraftServerConfig()
        online = []
        playersOnline = 0
    }
}


struct MinecraftServerConfig: Codable {
    let autoStart: Bool
    let autoUpdate: Bool
    let version: String
    let category: String
    let startCommand: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.autoStart = try container.decode(Bool.self, forKey: .autoStart)
        self.autoUpdate = try container.decode(Bool.self, forKey: .autoUpdate)
        self.version = try container.decode(String.self, forKey: .version)
        self.category = try container.decode(String.self, forKey: .category)
        self.startCommand = try container.decode(String.self, forKey: .startCommand)
    }
    
    init(){
        autoStart = false
        autoUpdate = false
        version = ""
        category = ""
        startCommand = ""
    }
}

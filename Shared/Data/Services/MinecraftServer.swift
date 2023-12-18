//
//  MinecraftServer.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/7/23.
//

import Foundation
import SwiftUI

class MinecraftServer: Codable, Identifiable, ObservableObject {
    
    var id: String { return name }
    @Published var filePath: String
    @Published var status: String
    @Published var name: String
    @Published var serverProperties: [String: String]
    @Published var serverConfig: MinecraftServerConfig
    @Published var online: [String]
    var playersOnline: Int { return online.count }
    
    private enum CodingKeys: String, CodingKey {
        case filePath
        case status
        case name
        case serverProperties
        case serverConfig
        case online
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(filePath, forKey: .filePath)
        try container.encode(status, forKey: .status)
        try container.encode(name, forKey: .name)
        try container.encode(serverProperties, forKey: .serverProperties)
        try container.encode(serverConfig, forKey: .serverConfig)
        try container.encode(online, forKey: .online)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.filePath = try container.decode(String.self, forKey: .filePath)
        self.status = try container.decode(String.self, forKey: .status)
        self.name = try container.decode(String.self, forKey: .name)
        self.serverProperties = try container.decode([String : String].self, forKey: .serverProperties)
        self.serverConfig = try container.decode(MinecraftServerConfig.self, forKey: .serverConfig)
        self.online = try container.decode([String].self, forKey: .online)
    }
    
    init(
        name: String = "",
        filePath: String = "",
        status: String = "",
        serverProperties: [String:String] = [:],
        online: [String] = [],
        serverConfig: MinecraftServerConfig = MinecraftServerConfig()
    ) {
        self.name = name
        self.filePath = filePath
        self.status = status
        self.serverProperties = serverProperties
        self.serverConfig = serverConfig
        self.online = online
    }
    
    static func == (lhs: MinecraftServer, rhs: MinecraftServer) -> Bool {
        lhs.name == rhs.name
    }
    
    func statusFill() -> Color {
        switch status {
        case "Online":
            return Color("Online")
        case "Offline":
            return Color("Offline")
        case "Crashed":
            return Color("Crashed")
        case "Updating":
            return Color("Updating")
        case "Starting", "Stopping":
            return Color("Transitioning")
        default:
            return Color("Crashed")
        }
    }
}


class MinecraftServerConfig: Codable, ObservableObject {
    @Published var autoStart: Bool
    @Published var autoUpdate: Bool
    @Published var version: String
    @Published var category: String
    @Published var startCommand: String
    
    private enum CodingKeys: String, CodingKey {
        case autoStart
        case autoUpdate
        case version
        case category
        case startCommand
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(autoStart, forKey: .autoStart)
        try container.encode(autoUpdate, forKey: .autoUpdate)
        try container.encode(version, forKey: .version)
        try container.encode(category, forKey: .category)
        try container.encode(startCommand, forKey: .startCommand)
    }
    
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

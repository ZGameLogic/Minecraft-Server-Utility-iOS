//
//  StompMessageFrame.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/17/23.
//

import Foundation

struct PlayersMessage: Decodable {
    let messageType: String
    let players: [String]
    let playerCount: Int
    let server: String
    
    enum CodingKeys: String, CodingKey {
        case messageType
        case players
        case playerCount
        case server
        case message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.messageType = try container.decode(String.self, forKey: .messageType)
        self.server = try container.decode(String.self, forKey: .server)
        
        let messageContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .message)
        self.players = try messageContainer.decode([String].self, forKey: .players)
        self.playerCount = try messageContainer.decode(Int.self, forKey: .playerCount)
    }
}

struct GeneralMessage: Decodable {
    let message: String
}

struct StompMessageFrame: Decodable {
    let messageType: String
    let server: String
}

//
//  MCServerCreation.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/20/23.
//

import Foundation

public struct MCServerCreationData: Encodable {
    let name: String
    let port: Int
    let autoStart: Bool
    let autoUpdate: Bool
    let version: String
    let category: String
    let startCommand: String
}

public struct CompletionMessage: Decodable {
    let message: String
    let success: Bool
    let data: [String: String]?
    
    enum CodingKeys: CodingKey {
        case message
        case success
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decode(String.self, forKey: .message)
        self.success = try container.decode(Bool.self, forKey: .success)
        if(!success){
            self.data = try container.decodeIfPresent([String : String].self, forKey: .data)
        } else {
            self.data = Optional.none
        }
    }
}

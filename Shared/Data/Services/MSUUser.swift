//
//  MSUUser.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/12/23.
//

import Foundation

struct MSUUser: Codable {
    
    let username: String
    let id: String
    let avatar: String
    let permissions: [String:String]
    let loggedIn: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decode(String.self, forKey: .username)
        self.id = try container.decode(String.self, forKey: .id)
        self.avatar = try container.decode(String.self, forKey: .avatar)
        self.permissions = try container.decode([String : String].self, forKey: .permissions)
        loggedIn = true
    }
    
    init(
        username: String = "",
        id: String = "",
        avatar: String = "",
        permissions: [String : String] = [:],
        loggedIn: Bool = false
    ) {
        self.username = username
        self.id = id
        self.avatar = avatar
        self.permissions = permissions
        self.loggedIn = loggedIn
    }
}

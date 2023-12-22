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
    let notifications: [String: NotificationSettings]
    let loggedIn: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decode(String.self, forKey: .username)
        self.id = try container.decode(String.self, forKey: .id)
        self.avatar = try container.decode(String.self, forKey: .avatar)
        self.permissions = try container.decode([String : String].self, forKey: .permissions)
        self.notifications = try container.decode([String : NotificationSettings].self, forKey: .notifications)
        loggedIn = true
    }
    
    init(
        username: String = "",
        id: String = "",
        avatar: String = "",
        permissions: [String : String] = [:],
        notifications: [String: NotificationSettings] = [:],
        loggedIn: Bool = false
    ) {
        self.username = username
        self.id = id
        self.avatar = avatar
        self.permissions = permissions
        self.notifications = notifications
        self.loggedIn = loggedIn
    }
}

struct NotificationSettings: Codable {
    let player: Bool
    let status: Bool
    let live: Bool
    let chat: Bool
}

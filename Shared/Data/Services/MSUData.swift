//
//  MSUData.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/30/23.
//

import Foundation

struct NotificationTogglePacket: Encodable {
    let server: String
    let notification: String
    
    init(server: String, notification: String) {
        self.server = server
        self.notification = notification
    }
}

struct MinecraftWidgetPacket: Decodable {
    
}

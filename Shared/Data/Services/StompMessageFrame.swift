//
//  StompMessageFrame.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/17/23.
//

import Foundation

struct StompMessageFrame: Codable {
    let messageType: String
    let message: String
    let server: String
}

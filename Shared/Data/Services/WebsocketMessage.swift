//
//  WebsocketMessage.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/19/23.
//

import Foundation

struct WebsocketMessage: Encodable {
    let action: String
    let userId: String
    let data: [String: String]
}

//
//  File.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 11/26/23.
//

import Foundation

struct Constants {
    static let API_BASE_URL = {
        #if DEBUG
        return "http://localhost:8080"
        #else
        return "https://zgamelogic.com:2010"
        #endif
    }()
    
    static let WEBSOCKET_URL = {
        #if DEBUG
        return "ws://localhost:8080/ws"
        #else
        return "wss://zgamelogic.com:2010/wss"
        #endif
    }()
    
    static let DISCORD_AUTH_URL = {
        #if DEBUG
        return "https://discord.com/api/oauth2/authorize?client_id=1182184476269363230&response_type=code&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Flogin%2Fcallback&scope=identify+email"
        #else
        return "https://discord.com/api/oauth2/authorize?client_id=1182184476269363230&response_type=code&redirect_uri=https%3A%2F%2Fzgamelogic.com%3A2010%2Flogin%2Fcallback&scope=identify+email"
        #endif
    }()
    
    static let DISCORD_REDIRECT_URL = {
        #if DEBUG
        return "http://localhost:3000/login/callback"
        #else
        return "https://zgamelogic.com:2010/login/callback"
        #endif
    }()
}

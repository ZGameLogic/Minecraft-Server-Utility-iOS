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
}

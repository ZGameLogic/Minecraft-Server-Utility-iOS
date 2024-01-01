//
//  MSU Service Widget.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/31/23.
//

import Foundation

class MSUServiceWidget {
    static func fetchWidgetPacket() async throws -> MinecraftWidgetPacket? {
        guard let url = URL(string: Constants.API_BASE_URL + "/widget/ios") else {return nil}
        let(data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("invalid response code")
            return nil
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(MinecraftWidgetPacket.self, from: data)
    }
}

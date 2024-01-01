//
//  MSU Service.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 10/3/23.
//

import Foundation

class MSUService {
    private init(){}
    
    static func login(code: String? = nil, id: String? = nil) async throws -> MSUUser? {
        var components = URLComponents(string: Constants.API_BASE_URL + "/auth/login")
        var queryItems: [URLQueryItem] = []
        if let code = code {queryItems.append(URLQueryItem(name: "code", value: code))}
        if let id = id {queryItems.append(URLQueryItem(name: "id", value: id))}
        if(queryItems.isEmpty) {return Optional.none}
        components?.queryItems = queryItems
        guard let url = components?.url else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        let(data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("invalid response code logging in")
            return nil
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(MSUUser.self, from: data)
    }
    
    
    static func fectchServers() async throws -> [MinecraftServer]{
        guard let url = URL(string: Constants.API_BASE_URL + "/servers") else {return []}
        let(data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("invalid response code fetching servers")
            return []
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode([MinecraftServer].self, from: data)
    }
    
    static func fetchServer(server: String) async throws -> MinecraftServer? {
        guard let url = URL(string: Constants.API_BASE_URL + "/servers/\(server)") else {return Optional.none}
        let(data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("invalid response code fetching server")
            return Optional.none
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode([MinecraftServer].self, from: data)[0]
    }
    
    static func fetchServerVersions() async throws -> [String: [String]] {
        let id = UserDefaults.standard.string(forKey: "id")!
        guard let url = URL(string: Constants.API_BASE_URL + "/server/versions") else { return [:] }
        
        var request = URLRequest(url: url)
        request.addValue(id, forHTTPHeaderField: "user")
        
        let(data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("invalid response code fetching server versions")
            return [:]
        }
        let decoder = JSONDecoder()
        return try decoder.decode([String: [String]].self, from: data)
    }
    
    static func validateServerInfo(creationData: MCServerCreationData) async throws -> CompletionMessage? {
        let id = UserDefaults.standard.string(forKey: "id")!
        guard let url = URL(string: Constants.API_BASE_URL + "/server/create/check") else { return Optional.none }
        
        var request = URLRequest(url: url)
        request.addValue(id, forHTTPHeaderField: "user")
        request.httpMethod = "POST"
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(creationData)
        request.httpBody = jsonData
        
        let(data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        return try decoder.decode(CompletionMessage.self, from: data)
    }
    
    static func createServer(creationData: MCServerCreationData) async throws -> CompletionMessage? {
        let id = UserDefaults.standard.string(forKey: "id")!
        guard let url = URL(string: Constants.API_BASE_URL + "/server/create") else { return Optional.none }
        
        var request = URLRequest(url: url)
        request.addValue(id, forHTTPHeaderField: "user")
        request.httpMethod = "POST"
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(creationData)
        request.httpBody = jsonData
        
        let(data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        return try decoder.decode(CompletionMessage.self, from: data)
    }
    
    static func registerDevice(token: String) async throws {
        try await registrationEndpoint(add: true, token: token)
    }
    
    static func unregisterDevice(token: String) async throws {
        try await registrationEndpoint(add: false, token: token)
    }
    
    static func toggleNotification(packet: NotificationTogglePacket) async throws {
        let id = UserDefaults.standard.string(forKey: "id")!
        guard let url = URL(string: Constants.API_BASE_URL + "/user/notifications/toggle") else { return }
        
        var request = URLRequest(url: url)
        request.addValue(id, forHTTPHeaderField: "user")
        request.httpMethod = "POST"
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(packet)
        request.httpBody = jsonData
        
        _ = try await URLSession.shared.data(for: request)
    }
    
    private static func registrationEndpoint(add: Bool, token: String) async throws {
        let id = UserDefaults.standard.string(forKey: "id")!
        guard let url = URL(string: Constants.API_BASE_URL + "/user/devices/\(add ? "register" : "unregister")/\(token)") else { return }
        
        var request = URLRequest(url: url)
        request.addValue(id, forHTTPHeaderField: "user")
        request.httpMethod = "POST"
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        _ = try await URLSession.shared.data(for: request)
    }
}

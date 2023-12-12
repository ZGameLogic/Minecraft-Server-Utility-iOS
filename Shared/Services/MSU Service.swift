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
            print("invalid response code")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(MSUUser.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
    
    
    static func fectchServers() async throws -> [MinecraftServer]{
        guard let url = URL(string: Constants.API_BASE_URL + "/servers") else {return []}
        let(data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("invalid response code")
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([MinecraftServer].self, from: data)
        } catch {
            print(error)
            return []
        }
    }
    
    static func fetchServer(server: String) async throws -> MinecraftServer? {
        guard let url = URL(string: Constants.API_BASE_URL + "/servers/\(server)") else {return Optional.none}
        let(data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("invalid response code")
            return Optional.none
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([MinecraftServer].self, from: data)[0]
        } catch {
            print(error)
            return Optional.none
        }
    }
    
//    static func fetchServerLog(server: String){
//        guard let url = URL(string: Constants.API_BASE_URL + "/server/log/\(server)") else {return}
//    }
//    
//    static func fetchServerVersions(){
//        guard let url = URL(string: Constants.API_BASE_URL + "/server/versions") else {return}
//    }
//    
//    static func validateServerInformation(data: String) {
//        guard let url = URL(string: Constants.API_BASE_URL + "/server/create/check") else {return}
//    }
//    
//    static func createServer(data: String){
//        guard let url = URL(string: Constants.API_BASE_URL + "/server/create") else {return}
//    }
}

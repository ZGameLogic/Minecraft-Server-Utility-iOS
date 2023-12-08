//
//  MSU Service.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 10/3/23.
//

import Foundation

class MSUService {
    private init(){}
    
    static func printAPI(){
        print(Constants.API_BASE_URL)
    }
    
    func fectchServers() async throws -> [MinecraftServer]{
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
    
    func fetchServerLog(server: String){
        guard let url = URL(string: Constants.API_BASE_URL + "/server/log/\(server)") else {return}
    }
    
    func fetchServerVersions(){
        guard let url = URL(string: Constants.API_BASE_URL + "/server/versions") else {return}
    }
    
    func validateServerInformation(data: String) {
        guard let url = URL(string: Constants.API_BASE_URL + "/server/create/check") else {return}
    }
    
    func createServer(data: String){
        guard let url = URL(string: Constants.API_BASE_URL + "/server/create") else {return}
    }
}

//
//  UserViewModel.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/18/23.
//

import Foundation

class User: ObservableObject {
    @Published var username: String
    @Published var id: String {
        didSet {
            UserDefaults.standard.set(id, forKey: "id")
        }
    }
    @Published var avatar: String
    @Published var permissions: [String:String]
    @Published var notifications: [String: NotificationSettings]
    @Published var loggedIn: Bool
    
    init(username: String = "", id: String = "", avatar: String = "", permissions: [String : String] = [:], notifications: [String: NotificationSettings] = [:], loggedIn: Bool = false) {
        self.username = username
        self.id = id
        self.avatar = avatar
        self.permissions = permissions
        self.loggedIn = loggedIn
        self.notifications = notifications
    }
    
    func update(user: MSUUser){
        username = user.username
        id = user.id
        avatar = user.avatar
        permissions = user.permissions
        notifications = user.notifications
        loggedIn = user.loggedIn
    }
    
    func logout(){
        username = ""
        id = ""
        avatar = ""
        permissions = [:]
        loggedIn = false
    }
    
    func hasPermission(server: String, permission: String) -> Bool {
        if(!loggedIn){ return false }
        if(permissions.keys.contains("General Permissions") && permissions["General Permissions"]!.contains("A")) { return true }
        return permissions.keys.contains(server) && permissions[server]!.contains(permission)
    }
}

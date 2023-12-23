//
//  Minecraft_Server_UtilityApp.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 10/3/23.
//

import SwiftUI

@main
struct Minecraft_Server_UtilityApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(User(id: UserDefaults.standard.string(forKey: "id") ?? ""))
                .environmentObject(MinecraftServersViewModel())
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        _ = response.notification.request.content.userInfo
//        guard let specialName = userInfo["special"] as? String,
//              let specialPriceString = userInfo["price"] as? String,
//              let specialPrice = Float(specialPriceString) else {
//            // Always call the completion handler when done.
//            completionHandler()
//            return
//        }

        // TODO open app somehow
        completionHandler()
     }
    
    func application(_ application: UIApplication,
               didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        subscribeToNotifications()
        UIApplication.shared.registerForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication,
                didRegisterForRemoteNotificationsWithDeviceToken
                    deviceToken: Data) {
        let tokenComponents = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let deviceTokenString = tokenComponents.joined()
        print("Submitting token")
        // TODO: Submit token to backend
        print(deviceTokenString)
    }


    func application(_ application: UIApplication,
                didFailToRegisterForRemoteNotificationsWithError
                    error: Error) {
       // Try again later.
    }
    
    func subscribeToNotifications() {
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: \(granted)")
        }
    }
    
    struct iosToken: Codable {
        let token: String
    }
}

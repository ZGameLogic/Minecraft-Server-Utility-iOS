//
//  ServerNotificationView.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/30/23.
//

import SwiftUI

struct ServerNotificationView: View {
    @EnvironmentObject private var user: User
    
    var body: some View {
        VStack {
            Text("Notifications")
                .font(.title)
                .padding()
            Form {
                ForEach(user.notifications.keys.sorted(), id: \.self) { server in
                    Section(header: Text(server)) {
                        Toggle("Player", isOn: Binding(
                            get: { user.notifications[server]?.player ?? false },
                            set: { user.notifications[server]?.player = $0 }
                        )).onChange(of: user.notifications[server]!.player){_, _ in
                            toggleNotification(server: server, value: "player")
                        }
                        Toggle("Status", isOn: Binding(
                            get: { user.notifications[server]?.status ?? false },
                            set: { user.notifications[server]?.status = $0 }
                        )).onChange(of: user.notifications[server]!.status){_, _ in
                            toggleNotification(server: server, value: "status")
                        }
                        Toggle("Live", isOn: Binding(
                            get: { user.notifications[server]?.live ?? false },
                            set: { user.notifications[server]?.live = $0 }
                        )).onChange(of: user.notifications[server]!.live){_, _ in
                            toggleNotification(server: server, value: "live")
                        }
                    }
                }
            }
        }
    }
    
    func toggleNotification(server: String, value: String){
        Task {
            try await MSUService.toggleNotification(packet: NotificationTogglePacket(server: server, notification: value))
        }
    }
}

#Preview {
    ServerNotificationView()
}

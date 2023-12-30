//
//  ServersUnavailableView.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/28/23.
//

import SwiftUI

struct ServersUnavailableView: View {
    var refresh: () -> Void
    
    var body: some View {
        ContentUnavailableView(label: {
            VStack {
                Image(systemName: "note.text.badge.plus")
                    .frame(width: 100, height: 100)
                    .scaledToFit()
                Text("No Servers Available")
                    .bold()
            }
        }, description: {
            Text("You may not be connected to the internet. If you are, and you have permissions, create a server using the button on the top right.")
        }, actions: {
            Button(action: {
                self.refresh()
            }){
                Text("Refresh")
            }
        })
    }
}

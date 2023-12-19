//
//  AddServerView.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/19/23.
//

import SwiftUI

struct AddServerView: View {
    @State var serverName = ""
    @Binding var isPresented: Bool
    var body: some View {
        NavigationStack {
            Form {
                TextField("Server Name", text: $serverName)
                
                ControlGroup {
                    
                }
            }.navigationTitle("Create Server")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel", action: { isPresented = false })
                    }
                    ToolbarItem {
                        Button("Create", action: {})
                    }
                }
        }
    }
}

#Preview {
    AddServerView(isPresented: Binding.constant(true))
}

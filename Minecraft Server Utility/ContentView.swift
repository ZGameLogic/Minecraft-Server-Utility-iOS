//
//  ContentView.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 10/3/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear(perform: {
            Task {
                do {
                    print(try await MSUService.fetchServer(server: "Test")!)
                } catch {
                    print(error)
                }
            }
        })
    }
}

#Preview {
    ContentView()
}

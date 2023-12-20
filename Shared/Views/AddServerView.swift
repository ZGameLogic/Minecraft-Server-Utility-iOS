//
//  AddServerView.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/19/23.
//

import SwiftUI

struct AddServerView: View {
    @State var serverName = ""
    @State var port = 25565
    @State var category = ""
    @State var version = ""
    @State var autoStart = false
    @State var autoUpdate = false
    @State var startCommand = "java -jar server.jar"
    @State var versionData: [String: [String]] = [:]
    
    @Binding var isPresented: Bool
    var body: some View {
        NavigationStack {
            Form {
                TextField("Server Name", text: $serverName, prompt: Text("ATM9"))
                Stepper(value: $port, in: 25565...29999, label: {
                    Text(verbatim: "Port: \(port)")
                        
                })
                ControlGroup {
                    Toggle("Auto Start", isOn: $autoStart)
                    Toggle("Auto Update", isOn: $autoUpdate)
                }
                ControlGroup {
                    Picker("Category", selection: $category){
                        ForEach(versionData.keys.sorted(by: >), id: \.self) {
                            Text($0)
                        }
                    }.onChange(of: category, {
                        version = versionData[category]!.first!
                    })
                    Picker("Version", selection: $version){
                        ForEach(versionData[category]?.sorted(by: >) ?? [], id: \.self) {
                            Text($0)
                        }
                    }
                }
                TextField("Start Script", text: $startCommand)
            }.navigationTitle("Create Server")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", action: { isPresented = false })
                        .foregroundColor(.red)
                }
                ToolbarItem {
                    Button("Create", action: {
                        
                    }).disabled(versionData.isEmpty)
                }
            }
        }.onAppear(){
            Task {
                do {
                    versionData = try await MSUService.fetchServerVersions()
                    if(!versionData.isEmpty){
                        category = "vanilla"
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}

#Preview {
    AddServerView(versionData: [
        "vanilla": ["1.20.4", ".1.20.3"],
        "AMT9": ["0.2.10", "0.3"]
    ], isPresented: Binding.constant(true))
}

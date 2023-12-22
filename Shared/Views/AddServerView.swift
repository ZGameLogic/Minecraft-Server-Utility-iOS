//
//  AddServerView.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/19/23.
//

import SwiftUI

struct AddServerView: View {
    @State var serverName = ""
    @State var serverNameError = ""
    @State var port = 25565
    @State var portError = ""
    @State var category = ""
    @State var version = ""
    @State var autoStart = false
    @State var autoUpdate = false
    @State var startCommand = "java -jar server.jar"
    @State var startCommandError = ""
    @State var versionData: [String: [String]] = [:]
    @State var isThinking = false
    @EnvironmentObject var servers: MinecraftServersViewModel
    
    @Binding var isPresented: Bool
    var body: some View {
        NavigationStack {
            Form {
                TextField("Server Name", text: $serverName, prompt: Text("ATM9"))
                if(!serverNameError.isEmpty){
                    Text("\(serverNameError)")
                        .foregroundStyle(.crashed)
                }
                Stepper(value: $port, in: 25565...29999, label: {
                    Text(verbatim: "Port: \(port)")
                })
                if(!portError.isEmpty){
                    Text("\(portError)")
                        .foregroundStyle(.crashed)
                }
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
                ControlGroup {
                    TextField("Start Script", text: $startCommand)
                    if(!startCommandError.isEmpty){
                        Text("\(startCommandError)")
                            .foregroundStyle(.crashed)
                    }
                }
            }.navigationTitle("Create Server")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel", action: { isPresented = false })
                            .foregroundColor(.red)
                    }
                    ToolbarItem {
                        Button("Create", action: submitServer).disabled(versionData.isEmpty || isThinking)
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
    
    func clearErrors(){
        serverNameError = ""
        portError = ""
        startCommandError = ""
    }
    
    func submitServer(){
        clearErrors()
        isThinking = true
        let creationData = MCServerCreationData(
            name: serverName,
            port: port,
            autoStart: autoStart,
            autoUpdate: autoUpdate,
            version: version,
            category: category,
            startCommand: startCommand
        )
        Task {
            do {
                guard let data = try await MSUService.validateServerInfo(creationData: creationData) else {
                    isThinking = false
                    return
                }
                if(data.success){
                    guard let data = try await MSUService.createServer(creationData: creationData) else {
                        isThinking = false
                        return
                    }
                    if(data.success){
                        print(data.message)
                        servers.refreshSevers()
                        isPresented = false
                    } else {
                        isThinking = false
                    }
                } else {
                    for error in data.data!.keys {
                        switch error {
                        case "name":
                            serverNameError = data.data![error]!
                            break
                        case "port":
                            portError = data.data![error]!
                            break
                        case "startCommand":
                            startCommandError = data.data![error]!
                            break
                        default:
                            break
                        }
                    }
                }
                isThinking = false
            } catch {
                isThinking = false
                print(error)
            }
        }
    }
}

#Preview {
    AddServerView(versionData: [
        "vanilla": ["1.20.4", "1.20.3", "2.3.5", "1.22"],
        "AMT9": ["0.2.10", "0.3"]
    ], isPresented: Binding.constant(true))
}

/**
 .sorted {
 let lhsStrings = $0.split(separator: ".")
 let lhs = [
     Int(lhsStrings.indices.contains(0) ? lhsStrings[0] : "0")!,
     Int(lhsStrings.indices.contains(1) ? lhsStrings[1] : "0")!,
     Int(lhsStrings.indices.contains(2) ? lhsStrings[2] : "0")!,
 ]
 let rhsStrings = $1.split(separator: ".")
 let rhs = [
     Int(rhsStrings.indices.contains(0) ? rhsStrings[0] : "0")!,
     Int(rhsStrings.indices.contains(1) ? rhsStrings[1] : "0")!,
     Int(rhsStrings.indices.contains(2) ? rhsStrings[2] : "0")!,
 ]
 for i in 0...2 {
     if(lhs[i] == rhs[i]) {continue}
     return lhs[i] > rhs[i]
 }
 return true
} 
 */

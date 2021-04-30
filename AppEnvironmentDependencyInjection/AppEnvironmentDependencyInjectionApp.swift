//
//  AppEnvironmentDependencyInjectionApp.swift
//  AppEnvironmentDependencyInjection
//
//  Created by ramil on 30.04.2021.
//

import SwiftUI

@main
struct AppEnvironmentDependencyInjectionApp: App {
    @StateObject var appEnvironment = AppEnvironment(fileClient: .live)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

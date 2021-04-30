//
//  AppEnvironment.swift
//  AppEnvironmentDependencyInjection
//
//  Created by ramil on 30.04.2021.
//

import Combine
import Foundation

class AppEnvironment: ObservableObject {
    
    var fileClient: FileClient
    
    init(fileClient: FileClient) {
        self.fileClient = fileClient
    }
}

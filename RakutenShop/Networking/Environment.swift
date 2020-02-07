//
//  Environment.swift
//  MVVM-C-Networking
//
//  Created by Garnik Ghazaryan on 1/22/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

enum Environments {
    case dev
    case production
    case qa
}

class Environment {
    
    private static let prodEnvirontment = "https://api.spoonacular.com"
    private static let devEnvironment = "https://api.spoonacular.com"
    private static let localDebug = "https://api.spoonacular.com"
    
    static func getEnvironment(env: Environments) -> String {
        switch env {
        case .dev:
            return devEnvironment
        case .production:
            return prodEnvirontment
        case .qa:
            return localDebug
        
        }
    }

}

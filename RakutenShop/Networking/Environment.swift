//
//  Environment.swift
//  MVVM-C-Networking
//
//  Created by Garnik Ghazaryan on 1/22/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import Foundation

enum Environments {
    case dev
    case production
    case qa

    private static let prodEnvirontment = "https://api.spoonacular.com"
    private static let devEnvironment = "https://api.spoonacular.com"
    private static let localDebug = "https://api.spoonacular.com"

    static func baseUrl(env: Environments) -> URL {
        let baseUrl: String = {
            switch env {
            case .dev:
                return devEnvironment
            case .production:
                return prodEnvirontment
            case .qa:
                return localDebug
            }
        }()
        return URL(string: baseUrl)!
    }
}

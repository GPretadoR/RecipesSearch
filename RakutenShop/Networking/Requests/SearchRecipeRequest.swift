//
//  SearchRecipeRequest.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/4/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

class SearchRecipeRequest: NetworkRequest {
    
    private let keyword: String
    
    init(keyword: String) {
        self.keyword = keyword
    }
    
    var baseURL: String {
        Environment.getEnvironment(env: .dev)
    }
    
    var path: String {
        "/recipes/search"
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var parameters: [String: String]? {
        ["query": keyword]
    }
}

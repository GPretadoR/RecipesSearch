//
//  RecipeAnalyzedInstructionsRequest.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/12/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import Alamofire

class RecipeAnalyzedInstructionsRequest: NetworkRequest {
    
    private let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    var path: String {
        "/recipes/\(id)/analyzedInstructions"
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
}

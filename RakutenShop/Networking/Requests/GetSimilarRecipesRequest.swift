//
//  GetSimilarRecipesRequest.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/13/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import Alamofire

class GetSimilarRecipesRequest: NetworkRequest {
    private let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    var path: String {
        "/recipes/\(id)/similar"
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
}

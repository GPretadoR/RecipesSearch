//
//  GetSimilarRecipesService.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/13/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import ReactiveSwift

class GetSimilarRecipesService {
    private let similarRecipesRequest: NetworkServiceProvider
    
    init(similarRecipesRequest: NetworkServiceProvider) {
        self.similarRecipesRequest = similarRecipesRequest
    }
    
    func getSimilarRecipes(id: Int) -> SignalProducer<[RecipeObject], Error> {
        let getSimilarRecipes = GetSimilarRecipesRequest(id: id)
        return similarRecipesRequest.requestJson(request: getSimilarRecipes, decodeType: [RecipeObject].self)
    }
}

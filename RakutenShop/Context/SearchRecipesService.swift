//
//  SearchRecipesService.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/5/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import ReactiveSwift

class SearchRecipesService {
    
    private let searchRequest: NetworkServiceProvider
    
    init(searchRequest: NetworkServiceProvider) {
        self.searchRequest = searchRequest
    }
    
    func getRecipes(keyword: String) -> SignalProducer<SearchRecipeResponseObject, Error> {
        let shopSearchRequest = SearchRecipeRequest(keyword: keyword)
        return searchRequest.requestJson(request: shopSearchRequest, decodeType: SearchRecipeResponseObject.self)
    }
}

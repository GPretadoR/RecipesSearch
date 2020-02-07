//
//  SearchRecipesService.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/5/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import ReactiveSwift

class SearchRecipesService {
    private let request = NetworkServiceProvider<SearchRecipeRequest>()
    
    func getRecipes(keyword: String) -> SignalProducer<SearchRecipeResponseObject, Error> {
        let shopSearchRequest = SearchRecipeRequest(keyword: keyword)
        return request.request(request: shopSearchRequest, decodeType: SearchRecipeResponseObject.self)
    }
}

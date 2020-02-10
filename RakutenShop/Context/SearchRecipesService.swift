//
//  SearchRecipesService.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/5/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import ReactiveSwift

class SearchRecipesService {
    #warning("this is better to inject from the outside, you can give as a argument in the constructor network")
    #warning("request is not appropriate name")
    private let request = NetworkServiceProvider<SearchRecipeRequest>()
    
    func getRecipes(keyword: String) -> SignalProducer<SearchRecipeResponseObject, Error> {
        let shopSearchRequest = SearchRecipeRequest(keyword: keyword)
        return request.request(request: shopSearchRequest, decodeType: SearchRecipeResponseObject.self)
    }
}

//
//  GetNutritionsService.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/12/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import ReactiveSwift

class GetNutritionsService {

    private let nutritionsRequest: NetworkServiceProvider
    
    init(nutritionsRequest: NetworkServiceProvider) {
        self.nutritionsRequest = nutritionsRequest
    }
    
    func getNutritions(id: Int) -> SignalProducer<NutritionsResponseObject, Error> {
        let recipeNutritions = RecipeNutritionRequest(id: id)
        return nutritionsRequest.requestJson(request: recipeNutritions, decodeType: NutritionsResponseObject.self)
    }
}

//
//  Services.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/5/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

class Services {
    let networkServiceProvider = NetworkServiceProvider(baseURL: Environments.baseUrl(env: .dev))
    
    let searchRecipesService: SearchRecipesService
    let recipeNutritionService: GetNutritionsService
    let recipeInstructionService: GetAnalyzedInstructionsService
    
    init() {
        self.searchRecipesService = SearchRecipesService(searchRequest: networkServiceProvider)
        self.recipeNutritionService = GetNutritionsService(nutritionsRequest: networkServiceProvider)
        self.recipeInstructionService = GetAnalyzedInstructionsService(analyzedInstructionsRequest: networkServiceProvider)
    }
}

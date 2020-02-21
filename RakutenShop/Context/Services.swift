//
//  Services.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/5/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

class Services {
    let networkServiceProvider = NetworkServiceProvider(baseURL: Environments.baseUrl(env: .dev))
    let databaseServiceProvider = DatabaseServiceProvider(persistentContainerName: Environments.persistentStoreName())
    
    let searchRecipesService: SearchRecipesService
    let recipeNutritionService: GetNutritionsService
    let recipeInstructionService: GetAnalyzedInstructionsService
    let getSimilarRecipes: GetSimilarRecipesService
    
    let saveRecipeToDBService: StoreRecipeDBService
    
    init() {
        searchRecipesService = SearchRecipesService(searchRequest: networkServiceProvider)
        recipeNutritionService = GetNutritionsService(nutritionsRequest: networkServiceProvider)
        recipeInstructionService = GetAnalyzedInstructionsService(analyzedInstructionsRequest: networkServiceProvider)
        getSimilarRecipes = GetSimilarRecipesService(similarRecipesRequest: networkServiceProvider)
        
        saveRecipeToDBService = StoreRecipeDBService(dbProvider: databaseServiceProvider)
    }
}

//
//  StoreRecipeDBService.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/20/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import Foundation

class StoreRecipeDBService {
    
    private let dbProvider: DatabaseServiceProvider
    
    init(dbProvider: DatabaseServiceProvider) {
        self.dbProvider = dbProvider
    }
    
    func getSavedRecipes() -> [RecipeObject] {
        return dbProvider.fetch(objectType: Recipe.self).map({ RecipeObject.recipeObject(recipe: $0) })
    }
    
    func storeRecipe(recipe: RecipeObject) {
        dbProvider.perform { (context) in
            let recipeModel = Recipe(context: context)
            recipeModel.title = recipe.title
            recipeModel.image = recipe.image
            recipeModel.imageUrls = recipe.imageUrls
            if let id = recipe.id, let readyInMinutes = recipe.readyInMinutes, let servings = recipe.servings {
                recipeModel.id = Int64(id)
                recipeModel.readyInMinutes = Int16(readyInMinutes)
                recipeModel.servings = Int16(servings)
            }
        }
    }
}

//
//  RecipeDetailViewViewModel.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/11/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import ReactiveSwift

class RecipeDetailViewViewModel {

    private let context: Context
    var recipeObject: MutableProperty<RecipeObject>?
    
    var nutritionsObject: MutableProperty<NutritionsResponseObject>?
    var analyzedInstructions: MutableProperty<[AnalyzedInstructionsResponseObject]>?
    
    init(context: Context) {
        self.context = context
    }
    
    func buildImageUrl(imageName: String) -> URL? {
        guard let imagesBaseUrl = context.imagesBaseUrl  else { return nil }
        guard let  url = URL(string: imagesBaseUrl + imageName) else { return nil }
        return url
    }
    
    func getInfo() {        
        guard let recipeId = recipeObject?.value.id else { return }
        context.services.recipeNutritionService.getNutritions(id: recipeId).on(value: {  nutritions in
            self.nutritionsObject = MutableProperty<NutritionsResponseObject>(nutritions)
//            self?.nutritionsObject?.
        }).on(failed: { error in
            print("Error nut", error)
        }).start()
        
        context.services.recipeInstructionService.getAnalyzedInstructions(id: recipeId).on(value: { [weak self] analyzedIngredientsObject in
            self?.analyzedInstructions = MutableProperty<[AnalyzedInstructionsResponseObject]>(analyzedIngredientsObject)
        }).on(failed: { error in
            print("Error inst", error)
        }).start()
    }
}

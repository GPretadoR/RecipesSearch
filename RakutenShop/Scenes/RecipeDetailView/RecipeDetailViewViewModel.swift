//
//  RecipeDetailViewViewModel.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/11/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import ReactiveSwift

protocol RecipeDetailViewCoordinatorDelegate: class {
    func didTapSaveButton()
    func didTapInstructionTableViewCell(instructions: AnalyzedInstructionsResponseObject)
    func didTapSimilarCollectionViewCell()
}

class RecipeDetailViewViewModel: BaseViewModel {

    private let context: Context
    weak var coordinatorDelegate: RecipeDetailViewCoordinatorDelegate?
    
    var recipeObject: MutableProperty<RecipeObject>
    
    var nutritionsObject = MutableProperty<NutritionsResponseObject?>(nil)
    var analyzedInstructions = MutableProperty<[AnalyzedInstructionsResponseObject]>([])
    var similarRecipes = MutableProperty<[RecipeObject]>([])
    
    init(context: Context, coordinatorDelegate: RecipeDetailViewCoordinatorDelegate, recipeObject: RecipeObject) {
        self.context = context
        self.coordinatorDelegate = coordinatorDelegate
        self.recipeObject = MutableProperty<RecipeObject>(recipeObject)
        super.init()
        getInfo()
    }
    
    func buildImageUrl(imageName: String) -> URL? {
        guard let imagesBaseUrl = context.imagesBaseUrl  else { return nil }
        guard let  url = URL(string: imagesBaseUrl + imageName) else { return nil }
        return url
    }
    
    func getInfo() {        
        guard let recipeId = recipeObject.value.id else { return }
        isLoading.value = true
        context.services.recipeNutritionService.getNutritions(id: recipeId).on(value: { [weak self] nutritions in
            self?.nutritionsObject.value = nutritions
            self?.isLoading.value = false
        }).on(failed: { [weak self] error in
            self?.isLoading.value = false
            self?.errorMessage.value = error.localizedDescription
        }).start()
        
        context.services.recipeInstructionService.getAnalyzedInstructions(id: recipeId).on(value: { [weak self] analyzedIngredientsObject in
            self?.analyzedInstructions.value = analyzedIngredientsObject
            self?.isLoading.value = false
        }).on(failed: { [weak self] error in
            self?.isLoading.value = false
            self?.errorMessage.value = error.localizedDescription
        }).start()
        
        context.services.getSimilarRecipes.getSimilarRecipes(id: recipeId).on(value: { [weak self] similarRecipes in
            self?.isLoading.value = false
            self?.similarRecipes.value = similarRecipes
        }).on(failed: { [weak self] error in
            self?.isLoading.value = false
            self?.errorMessage.value = error.localizedDescription
        }).start()
    }
    
    func didTapSaveButton() {
        context.services.saveRecipeToDBService.storeRecipe(recipe: recipeObject.value)
    }
    
    func didSelectItem(index: IndexPath) {        
        coordinatorDelegate?.didTapInstructionTableViewCell(instructions: analyzedInstructions.value[index.row])
    }
    
    func didSelectSimilarItem(indexPath: IndexPath) {
        let recipe = similarRecipes.value[indexPath.item]
        recipeObject.value = recipe
        getInfo()
    }
}

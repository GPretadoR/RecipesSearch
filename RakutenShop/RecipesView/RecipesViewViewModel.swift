//
//  RecipesViewViewModel.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/1/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//
import ReactiveSwift

protocol RecipesViewCoordinatorDelegate: class {
    func didSelectItem(at indexPath: IndexPath)
}

class RecipesViewViewModel {
    
    weak var coordinatorDelegate: RecipesViewCoordinatorDelegate?
    private let context: Context
    private var imagesBaseUrl: String = ""
    var recipeItems = MutableProperty<[RecipeObject]>([])
    var isLoading = MutableProperty<Bool>(false)
    var errorMessage = MutableProperty<String>("")
    
    init(context: Context, coordinatorDelegate: RecipesViewCoordinatorDelegate) {
        self.context = context
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    func getRecipe(keyword: String) {
        isLoading.value = true
        context.services.searchRecipesService
            .getRecipes(keyword: keyword)
            .on(value: { [weak self] (data) in
            if let imagesUrl = data.baseUri {
                self?.imagesBaseUrl = imagesUrl
            }
            if let recipes = data.results {
                self?.recipeItems.value = recipes
            }
            self?.isLoading.value = false
        }).on(failed: { [weak self] (error) in
            self?.isLoading.value = false
            self?.errorMessage.value = error.localizedDescription
        }).start()
    }
    
    #warning("this is not connected with the data downloading process")
    func buildImageUrl(id: Int) -> URL? {
        let imageSize = RecipeCollectionImageSizes.medium312by231.rawValue
        guard let  url = URL(string: imagesBaseUrl + "\(id)-\(imageSize).jpg") else { return nil }
        return url
    }
    
    func didTapItem(at indexPath: IndexPath) {
        coordinatorDelegate?.didSelectItem(at: indexPath)
    }
}

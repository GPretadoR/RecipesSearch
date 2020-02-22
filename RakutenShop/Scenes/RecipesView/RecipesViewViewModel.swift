//
//  RecipesViewViewModel.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/1/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//
import ReactiveSwift

protocol RecipesViewCoordinatorDelegate: class {
    func didSelectRecipe(recipe: RecipeObject)
    func didTapMyRecipesButton()
}

class RecipesViewViewModel: BaseViewModel {
    
    weak var coordinatorDelegate: RecipesViewCoordinatorDelegate?
    private let context: Context
    private var imagesBaseUrl: String = "" {
        didSet {
            context.imagesBaseUrl = self.imagesBaseUrl
        }
    }
    
    var recipeItems = MutableProperty<[RecipeObject]>([])
    
    let debounceInterval = 0.8
    
    init(context: Context, coordinatorDelegate: RecipesViewCoordinatorDelegate) {
        self.context = context
        self.coordinatorDelegate = coordinatorDelegate
        super.init()
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
        }).observe(on: UIScheduler()).start()
    }
    
    func buildImageUrl(id: Int) -> URL? {
        guard !imagesBaseUrl.isEmpty else { return nil }
        let imageSize = RecipeCollectionImageSizes.medium312by231.rawValue
        guard let  url = URL(string: imagesBaseUrl + "\(id)-\(imageSize).jpg") else { return nil }
        return url
    }
    
    func didTapItem(at indexPath: IndexPath) {
        let recipeObject = recipeItems.value[indexPath.item]
        coordinatorDelegate?.didSelectRecipe(recipe: recipeObject)
    }
    
    func didTapMyRecipesButton() {
        coordinatorDelegate?.didTapMyRecipesButton()
    }
}

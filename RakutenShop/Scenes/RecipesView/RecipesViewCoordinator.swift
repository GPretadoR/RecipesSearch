//
//  RecipesViewCoordinator.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/5/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import UIKit

class RecipesViewCoordinator: BaseCoordinator {
    private let context: Context
    private let window: UIWindow

    var recipeDetailCoordinator: RecipeDetailViewCoordinator?
    
    init(context: Context, window: UIWindow) {
        self.context = context
        self.window = window
        let navigationController = UINavigationController()
        super.init(rootController: navigationController)

        if let viewController = R.storyboard.main.recipesViewController() {
            navigationController.pushViewController(viewController, animated: false)
            let viewModel = RecipesViewViewModel(context: context, coordinatorDelegate: self)
            viewController.viewModel = viewModel
        }
    }
    
    override func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}

extension RecipesViewCoordinator: RecipesViewCoordinatorDelegate {
    func didSelectRecipe(recipe: RecipeObject) {
        recipeDetailCoordinator = RecipeDetailViewCoordinator(context: context, coordinator: self, recipeObject: recipe)
        recipeDetailCoordinator?.recipeObject = recipe
        recipeDetailCoordinator?.start()
    }
}

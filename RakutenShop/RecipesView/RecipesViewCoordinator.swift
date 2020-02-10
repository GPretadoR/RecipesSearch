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

    init(context: Context, window: UIWindow) {
        self.context = context
        self.window = window
        let navigationController = UINavigationController()
        super.init(rootController: navigationController)
        
        #warning("in the init is taking place this line ))) you don't need it here")
        self.navigationController = navigationController
        if let viewController = R.storyboard.main.recipesViewController() {
            navigationController.pushViewController(viewController, animated: false)
            let viewModel = RecipesViewViewModel(context: context, coordinatorDelegate: self)
            viewController.viewModel = viewModel
        }
    }
    
    override func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension RecipesViewCoordinator: RecipesViewCoordinatorDelegate {
    func didSelectItem(at indexPath: IndexPath) {
        
    }
    
}

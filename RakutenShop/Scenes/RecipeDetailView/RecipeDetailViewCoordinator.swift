//
//  RecipeDetailViewCoordinator.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/11/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import UIKit
import ReactiveSwift

class RecipeDetailViewCoordinator: BaseCoordinator {

    private let context: Context
    private var viewController: RecipeDetailViewController?
    var recipeDetailCoordinator: StepListViewCoordinator?
    var recipeObject: RecipeObject?
    
    init(context: Context, coordinator: BaseCoordinator) {
        self.context = context
        super.init(coordinator: coordinator)
        self.viewController = R.storyboard.main.recipeDetailViewController()
        guard let viewController = viewController else { return }
        let viewModel = RecipeDetailViewViewModel(context: context, coordinatorDelegate: self)
        viewController.viewModel = viewModel
    }
    
    override func start() {
        guard let viewController = viewController, let rootNavController = rootViewController as? UINavigationController else { return }
        rootNavController.pushViewController(viewController, animated: true)
        guard let recipeObject = recipeObject else { return }
        viewController.viewModel?.recipeObject = MutableProperty<RecipeObject>(recipeObject)
        viewController.viewModel?.getInfo()
    }
}

extension RecipeDetailViewCoordinator: RecipeDetailViewCoordinatorDelegate {
    func didTapSaveButton() {
        
    }
    
    func didTapInstructionTableViewCell(instructions: AnalyzedInstructionsResponseObject) {
        recipeDetailCoordinator = StepListViewCoordinator(context: context, coordinator: self)
        recipeDetailCoordinator?.instructions = instructions
        recipeDetailCoordinator?.start()
    }
    
    func didTapSimilarCollectionViewCell() {
        
    }
}

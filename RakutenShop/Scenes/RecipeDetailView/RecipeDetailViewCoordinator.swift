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
    var recipeObject: RecipeObject
    
    init(context: Context, coordinator: BaseCoordinator, recipeObject: RecipeObject) {
        self.context = context
        self.recipeObject = recipeObject
        super.init(coordinator: coordinator)
        viewController = R.storyboard.main.recipeDetailViewController()
        guard let viewController = viewController else { return }
        let viewModel = RecipeDetailViewViewModel(context: context, coordinatorDelegate: self, recipeObject: recipeObject)
        viewController.viewModel = viewModel
    }
    
    override func start() {
        guard let viewController = viewController, let rootNavController = rootViewController as? UINavigationController else { return }
        rootNavController.pushViewController(viewController, animated: true)
    }
}

extension RecipeDetailViewCoordinator: RecipeDetailViewCoordinatorDelegate {
    func didTapSaveButton() {
        
    }
    
    func didTapInstructionTableViewCell(instructions: AnalyzedInstructionsResponseObject) {
        recipeDetailCoordinator = StepListViewCoordinator(context: context, coordinator: self, instructions: instructions)
        recipeDetailCoordinator?.instructions = instructions
        recipeDetailCoordinator?.start()
    }
    
    func didTapSimilarCollectionViewCell() {
        
    }
}

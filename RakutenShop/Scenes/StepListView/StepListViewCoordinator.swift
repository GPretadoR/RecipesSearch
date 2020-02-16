//
//  StepListViewCoordinator.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/13/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import UIKit
import ReactiveSwift

class StepListViewCoordinator: BaseCoordinator {

    private let context: Context
    private var viewController: StepListViewController?
    private var detailedInstructionsCoordinator: DetailedInstructionsViewCoordinator?
    
    var instructions: AnalyzedInstructionsResponseObject
    
    init(context: Context, coordinator: BaseCoordinator, instructions: AnalyzedInstructionsResponseObject) {
        self.context = context
        self.instructions = instructions
        super.init(coordinator: coordinator)
        viewController = R.storyboard.main.stepListViewController()
        guard let viewController = viewController else { return }
        let viewModel = StepListViewViewModel(context: context, coordinatorDelegate: self, analyzedInstructions: instructions)
        viewController.viewModel = viewModel
    }
    
    override func start() {
        guard let viewController = viewController, let rootNavController = rootViewController as? UINavigationController else { return }
        rootNavController.pushViewController(viewController, animated: true)
    }
    
}

extension StepListViewCoordinator: StepListViewCoordinatorDelegate {
    func didTapItem(step: Steps) {
        detailedInstructionsCoordinator = DetailedInstructionsViewCoordinator(context: context, coordinator: self)
        detailedInstructionsCoordinator?.step = step
        detailedInstructionsCoordinator?.start()
    }
}

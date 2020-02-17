//
//  DetailedInstructionsViewCoordinator.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/14/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import ReactiveSwift

class DetailedInstructionsViewCoordinator: BaseCoordinator {
    
    private let context: Context
    private var viewController: DetailedInstructionsViewController?
    
    var step: Steps
    
    init(context: Context, coordinator: BaseCoordinator, step: Steps) {
        self.context = context
        self.step = step
        super.init(coordinator: coordinator)
        self.viewController = R.storyboard.main.detailedInstructionsViewController()
        guard let viewController = viewController else { return }
        let viewModel = DetailedInstructionsViewViewModel(context: context, coordinatorDelegate: self, step: step)
        viewController.viewModel = viewModel
    }
    
    override func start() {
        guard let viewController = viewController, let rootNavController = rootViewController as? UINavigationController else { return }
        rootNavController.pushViewController(viewController, animated: true)
    }
}

extension DetailedInstructionsViewCoordinator: DetailedInstructionsViewCoordinatorDelegate {
    
}

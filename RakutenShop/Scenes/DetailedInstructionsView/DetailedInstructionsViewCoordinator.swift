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
    
    var step: Steps?
    
    init(context: Context, coordinator: BaseCoordinator) {
        self.context = context
        super.init(coordinator: coordinator)
        self.viewController = R.storyboard.main.detailedInstructionsViewController()
        guard let viewController = viewController else { return }
        let viewModel = DetailedInstructionsViewViewModel(context: context, coordinatorDelegate: self)
        viewController.viewModel = viewModel
    }
    
    override func start() {
        guard let viewController = viewController, let rootNavController = rootViewController as? UINavigationController else { return }
        rootNavController.pushViewController(viewController, animated: true)
        guard let step = step else { return }
        viewController.viewModel?.steps = MutableProperty<Steps>(step)
    }
}

extension DetailedInstructionsViewCoordinator: DetailedInstructionsViewCoordinatorDelegate {
    
}

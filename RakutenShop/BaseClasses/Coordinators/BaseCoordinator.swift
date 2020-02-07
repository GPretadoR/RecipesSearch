//
//  BaseCoordinator.swift
//  MVVM-C-Networking
//
//  Created by Garnik Ghazaryan on 1/22/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import UIKit

class BaseCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    
    var storyboard: UIStoryboard {
        UIStoryboard(name: "Main", bundle: nil)
    }
    
    init(rootController: UINavigationController) {
        self.navigationController = rootController
    }
    
    init(coordinator: BaseCoordinator) {
        self.navigationController = coordinator.navigationController
    }
    
    func start() {}
}

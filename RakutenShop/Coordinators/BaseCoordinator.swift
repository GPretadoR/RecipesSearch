//
//  BaseCoordinator.swift
//  MVVM-C-Networking
//
//  Created by Garnik Ghazaryan on 1/22/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import UIKit

class BaseCoordinator: Coordinator {

    var rootViewController: UIViewController?
    
    init(rootController: UINavigationController) {
        self.rootViewController = rootController
    }
    
    init(coordinator: BaseCoordinator) {
        self.rootViewController = coordinator.rootViewController
    }
    
    func start() {}
    
}

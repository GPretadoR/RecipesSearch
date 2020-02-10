//
//  BaseCoordinator.swift
//  MVVM-C-Networking
//
//  Created by Garnik Ghazaryan on 1/22/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import UIKit

class BaseCoordinator: Coordinator {

    #warning("I can suggest to use viewController instead of navigationController as it is more generic and to rename it as rootController or something like more generic")
    var navigationController: UINavigationController?
  
    #warning("you don't use this variable and anyway I am not thinking this one is good place")
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

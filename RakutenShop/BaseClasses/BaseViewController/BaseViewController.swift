//
//  BaseViewController.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/6/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import UIKit
import SVProgressHUD

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setContainerView(self.view)
        SVProgressHUD.setMaximumDismissTimeInterval(2.5)
        // Do any additional setup after loading the view.
        setupViewModel()
    }
    
    override func loadView() {
        super.loadView()
        setupView()
    }

    func setupView() {
        self.view.backgroundColor = .lightGray
    }

    func setupViewModel() {
        
    }
}

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
    }
    open func setupView() {
    }

    open func setupViewModel() {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

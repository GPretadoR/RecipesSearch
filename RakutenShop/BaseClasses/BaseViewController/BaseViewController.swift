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
    
    #warning("I am thinking this function should be called after creating the object, in the init and awake from nib functions that it will be called automatically after overriding in the subclasses")
    #warning("why the function is open?")
    open func setupView() {
    }

    #warning("this also should be called in the initialization that you can just override it and it will be called automatically")
    #warning("why the function is open?")
    open func setupViewModel() {
        
    }
    
    #warning("remove this kind of comments")
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

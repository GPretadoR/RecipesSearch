//
//  HTTPMethod.swift
//  MVVM-C-Networking
//
//  Created by Garnik Ghazaryan on 1/22/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import UIKit

#warning("in the Alamofire should be method type, it would be good decision to use the Alamofire methods")
enum HTTPMethod: String {
    case get
    case post
    case put
    case patch
    case delete    
}

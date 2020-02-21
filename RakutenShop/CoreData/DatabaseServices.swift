//
//  DatabaseServices.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/18/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import CoreData

protocol DatabaseServices {
    
    associatedtype T
    associatedtype Output
    
    func fetch<Output>(objectType: Output.Type) -> [Output] 
}

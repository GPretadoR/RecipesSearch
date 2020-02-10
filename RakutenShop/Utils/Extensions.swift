//
//  Extensions.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/10/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import Foundation

extension Collection {
    var nonEmpty: Self? {
        return isEmpty ? nil : self
    }
    
    func element(at index: Index) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}

//
//  BaseViewModel.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/13/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import ReactiveSwift

class BaseViewModel {
    var isLoading = MutableProperty<Bool>(false)
    var errorMessage = MutableProperty<String>("")
    var successMessage = MutableProperty<String>("")
}

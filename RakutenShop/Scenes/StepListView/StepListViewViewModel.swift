//
//  StepListViewViewModel.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/13/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import ReactiveSwift

class StepListViewViewModel: BaseViewModel {

    private let context: Context

    var analyzedInstructions = MutableProperty<AnalyzedInstructionsResponseObject>(AnalyzedInstructionsResponseObject(name: "", steps: []))
    
    init(context: Context) {
        self.context = context
        super.init()
    }
    
}

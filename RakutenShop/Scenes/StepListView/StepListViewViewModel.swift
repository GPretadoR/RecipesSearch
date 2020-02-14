//
//  StepListViewViewModel.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/13/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import ReactiveSwift

protocol StepListViewCoordinatorDelegate: class {
    func didTapItem(step: Steps)
}

class StepListViewViewModel: BaseViewModel {

    private let context: Context
    weak var coordinatorDelegate: StepListViewCoordinatorDelegate?

    var analyzedInstructions = MutableProperty<AnalyzedInstructionsResponseObject>(AnalyzedInstructionsResponseObject(name: "", steps: []))
    
    init(context: Context, coordinatorDelegate: StepListViewCoordinatorDelegate) {
        self.context = context
        self.coordinatorDelegate = coordinatorDelegate
        super.init()
    }
    
    func didSelectRow(indexPath: IndexPath) {
        guard let step = analyzedInstructions.value.steps?[indexPath.row] else { return }
        coordinatorDelegate?.didTapItem(step: step)
    }
}

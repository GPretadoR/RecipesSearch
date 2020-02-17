//
//  DetailedInstructionsViewViewModel.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/14/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import ReactiveSwift

protocol DetailedInstructionsViewCoordinatorDelegate: class {
    
}

enum InstructionType: String {
    case ingredient
    case equipment
}

class DetailedInstructionsViewViewModel: BaseViewModel {
    
    private let context: Context
    weak var coordinatorDelegate: DetailedInstructionsViewCoordinatorDelegate?
    
    let imagesBaseUrl = "https://spoonacular.com/cdn/"
    
    var steps: MutableProperty<Steps>
    
    init(context: Context, coordinatorDelegate: DetailedInstructionsViewCoordinatorDelegate, step: Steps) {
        self.context = context
        self.coordinatorDelegate = coordinatorDelegate
        self.steps = MutableProperty<Steps>(step)
        super.init()
    }
    
    func buildImageUrl(instructionType: InstructionType, imageName: String) -> URL? {
        var imageUrl = imagesBaseUrl
        switch instructionType {
        case .ingredient:
            imageUrl.append(InstructionType.ingredient.rawValue)
        case .equipment:
            imageUrl.append(InstructionType.equipment.rawValue)
        }
        imageUrl.append("_100x100/")
        guard let  url = URL(string: imageUrl + imageName) else { return nil }
        return url
    }
}

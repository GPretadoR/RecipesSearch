//
//  GetAnalyzedInstructionsService.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/12/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import ReactiveSwift

class GetAnalyzedInstructionsService {

    private let analyzedInstructionsRequest: NetworkServiceProvider
    
    init(analyzedInstructionsRequest: NetworkServiceProvider) {
        self.analyzedInstructionsRequest = analyzedInstructionsRequest
    }
    
    func getAnalyzedInstructions(id: Int) -> SignalProducer<[AnalyzedInstructionsResponseObject], Error> {
        let analyzedInstructions = RecipeAnalyzedInstructionsRequest(id: id)
        return analyzedInstructionsRequest.requestJson(request: analyzedInstructions, decodeType: [AnalyzedInstructionsResponseObject].self)
    }
}

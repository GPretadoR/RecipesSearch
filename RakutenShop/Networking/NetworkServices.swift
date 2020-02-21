//
//  NetworkServices.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/18/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import ReactiveSwift

protocol NetworkServices {
    associatedtype T
    associatedtype Output
    
//    func request(request: T, completion:@escaping(Result<Data>) -> Void)
//    func request<U>(request: T, decodeType: U.Type, completion:@escaping(Result<U>) -> Void) where U: Decodable
    func requestData<T: NetworkRequest>(request: T) -> SignalProducer<Data, Error>
    func requestJson<T: NetworkRequest, U: Decodable>(request: T, decodeType: U.Type) -> SignalProducer<U, Error>
}

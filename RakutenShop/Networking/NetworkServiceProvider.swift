//
//  NetworkServiceProvider.swift
//  MVVM-C-Networking
//
//  Created by Garnik Ghazaryan on 1/22/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import ReactiveSwift
import Alamofire
import Foundation

protocol NetworkServices {
    #warning("I will suggest in this case to have more descriptive names, like U -> Output")
    associatedtype T
    associatedtype U
    
    func request(request: T, completion:@escaping(Result<Data>) -> Void)
    func request<U>(request: T, decodeType: U.Type, completion:@escaping(Result<U>) -> Void) where U: Decodable
    func request<T: NetworkRequest>(request: T) -> SignalProducer<Data, Error>
}

class NetworkServiceProvider<T: NetworkRequest>: NetworkServices {
    
    private let urlSession = URLSession.shared
    private let queue = DispatchQueue(label: "Network")
    private let session = Alamofire.SessionManager()
    typealias T = T
    
    typealias U = Decodable
    
    #warning("why do we have requests we reactive and not reactive, it is strange for me?")
    func request(request: T, completion: @escaping(Result<Data>) -> Void) {
        call(request: request.urlRequest, completion: completion)
    }
    
    func request<U>(request: T, decodeType: U.Type, completion: @escaping(Result<U>) -> Void) where U: Decodable {
        call(request: request.urlRequest) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let json = try decoder.decode(decodeType, from: data)
                    completion(.success(json))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func request<T: NetworkRequest>(request: T) -> SignalProducer<Data, Error> {
        return reactiveCall(request: request.urlRequest)
    }
    
    #warning("from the function name it is not understandable that this is returns json and other one is not")
    func request<T: NetworkRequest, U: Decodable>(request: T, decodeType: U.Type) -> SignalProducer<U, Error> {
        return reactiveCallDecodable(request: request.urlRequest, decodeType: decodeType)
    }
    
    private func reactiveCallDecodable<U: Decodable>(request: URLRequest, decodeType: U.Type) -> SignalProducer<U, Error> {
        return SignalProducer { [weak self] observer, lifetime in
            #warning("Suggestion: guard let self = self else { return }")
            guard let weakSelf = self else { return }
            //TODO: Add do catch
            let dataRequest = weakSelf.session.request(request).responseData(queue: weakSelf.queue) { (dataResponse) in
                switch dataResponse.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    do {
                        let json = try decoder.decode(decodeType, from: data)
                        observer.send(value: json)
                        observer.sendCompleted()
                    } catch {
                        observer.send(error: error)
                    }
                case .failure(let error):
                    observer.send(error: error)
                }
            }
            lifetime.observeEnded {
                dataRequest.cancel()
            }
        }
    }
    
    #warning("I don't understand why do you have reactivecall and call?????")
    private func reactiveCall(request: URLRequest) -> SignalProducer<Data, Error> {
        return SignalProducer { [weak self] observer, lifetime in
            #warning("I am suggesting to write \"guard let self = self else { return }")
            guard let weakSelf = self else { return }
            //TODO: Add do catch
            let dataRequest = weakSelf.session.request(request).responseData(queue: weakSelf.queue) { (dataResponse) in
                switch dataResponse.result {
                case .success(let data):
                    observer.send(value: data)
                    observer.sendCompleted()
                case .failure(let error):
                    observer.send(error: error)
                }
            }
            lifetime.observeEnded {
                dataRequest.cancel()
            }
        }
    }
    
    private func call(request: URLRequest, completion: @escaping(Result<Data>) -> Void) {
        urlSession.dataTask(with: request) { (data, _, error) in
            if let error = error {
                self.queue.async {
                    completion(.failure(error))
                }
            }
            if let data = data {
                self.queue.async {
                    completion(.success(data))
                }
            }
        }.resume()
    }
}

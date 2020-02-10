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
    associatedtype T
    associatedtype Output
    
//    func request(request: T, completion:@escaping(Result<Data>) -> Void)
//    func request<U>(request: T, decodeType: U.Type, completion:@escaping(Result<U>) -> Void) where U: Decodable
    func requestData<T: NetworkRequest>(request: T) -> SignalProducer<Data, Error>
    func requestJson<T: NetworkRequest, U: Decodable>(request: T, decodeType: U.Type) -> SignalProducer<U, Error>
}

class NetworkServiceProvider: NetworkServices {
    
    private let urlSession = URLSession.shared
    private let queue = DispatchQueue(label: "Network")
    private let session = Alamofire.SessionManager()
    typealias T = NetworkRequest
    
    typealias Output = Decodable
    
    let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
//    func request(request: T, completion: @escaping(Result<Data>) -> Void) {
//        call(request: request.urlRequest, completion: completion)
//    }
//
//    func request<U>(request: T, decodeType: U.Type, completion: @escaping(Result<U>) -> Void) where U: Decodable {
//        call(request: request.urlRequest) { result in
//            switch result {
//            case .success(let data):
//                let decoder = JSONDecoder()
//                do {
//                    let json = try decoder.decode(decodeType, from: data)
//                    completion(.success(json))
//                } catch {
//                    completion(.failure(error))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
     
    func requestData<T: NetworkRequest>(request: T) -> SignalProducer<Data, Error> {
        return reactiveCall(request: request)
    }
    
    func requestJson<T: NetworkRequest, U: Decodable>(request: T, decodeType: U.Type) -> SignalProducer<U, Error> {
        return reactiveCallDecodable(request: request, decodeType: decodeType)
    }
    
    private func reactiveCallDecodable<U: Decodable>(request: T, decodeType: U.Type) -> SignalProducer<U, Error> {
        return SignalProducer { [weak self] observer, lifetime in
            guard let self = self else { return }
            //TODO: Add do catch
            do {
                let urlRequest = try self.makeURLRequest(request)
                let dataRequest = self.session.request(urlRequest)
                    .validate(self.makeValidator())
                    .responseData(queue: self.queue) { (dataResponse) in
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
            } catch {
                observer.send(error: error)
            }
        }
    }
    
    private func reactiveCall(request: T) -> SignalProducer<Data, Error> {
        return SignalProducer { [weak self] observer, lifetime in
            guard let self = self else { return }
            //TODO: Add do catch
            do {
                let urlRequest = try self.makeURLRequest(request)
                let dataRequest = self.session.request(urlRequest)
                    .validate(self.makeValidator())
                    .responseData(queue: self.queue) { (dataResponse) in
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
            } catch {
                observer.send(error: error)
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
    
    private func makeURLRequest(_ request: T) throws -> URLRequest {
        let baseURL = request.baseURL ?? self.baseURL
        let url = request.path.nonEmpty.flatMap { baseURL.appendingPathComponent($0) } ?? baseURL
        
        var urlRequest = try URLRequest(url: url, method: request.httpMethod, headers: request.customHeaders)
        //           if let authorizationStrategy = request.authorizationStrategy {
        //
        //               if authorizationStrategy == .token, let token = sessionTokenProvider?.sessionToken.value?.accessToken {
        //                   urlRequest.headers.add(.authorization(bearerToken: token))
        //               }
        //           }
        if var queryParameters = request.queryParameters {
            queryParameters.updateValue("c5033dfeabae490e9e1cfc32e727eca0", forKey: "apiKey")
            let encoding = URLEncoding(destination: .queryString,
                                       arrayEncoding: .noBrackets,
                                       boolEncoding: .numeric)
            urlRequest = try encoding.encode(urlRequest, with: queryParameters)
        }
        if let bodyParameters = request.bodyParameters {
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: bodyParameters)
        }
        if let timeoutInterval = request.timeoutInterval {
            urlRequest.timeoutInterval = timeoutInterval
        }
        return urlRequest
    }
    
    struct ErrorResponse: Decodable {
        let error: String
    }
    
    private func makeValidator() -> DataRequest.Validation {
        return { (request, response, data) in
            if 200 ..< 400 ~= response.statusCode {
                return .success
            } else if let data = data {
                let result = Result { try JSONDecoder().decode(ErrorResponse.self, from: data) }
                switch result {
                case .success(let errorResponse):
                    return .failure(APIError(codeValue: errorResponse.error, httpCode: response.statusCode))
                case .failure:
                    if let message = String(data: data, encoding: .utf8) {
                        print("[\(response.statusCode)] \(message)")
                    }
                    return .failure(APIError(code: .invalidErrorFormat, httpCode: response.statusCode))
                }
            } else {
                return .failure(APIError(code: .emptyData, httpCode: response.statusCode))
            }
        }
    }
}

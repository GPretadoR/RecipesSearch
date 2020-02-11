//
//  NetworkRequest.swift
//  MVVM-C-Networking
//
//  Created by Garnik Ghazaryan on 1/22/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkRequest {
    var baseURL: URL? { get }
    var path: String { get }
    var queryParameters: [String: String]? { get }
    var bodyParameters: [String: String]? { get }
    var httpMethod: HTTPMethod { get }
    var customHeaders: [String: String]? { get }
    var authorizationStrategy: AuthorizationStrategy? { get }
    var timeoutInterval: TimeInterval? { get }
    
}

extension NetworkRequest {
    var baseURL: URL? { nil }
    var queryParameters: [String: String]? { nil }
    var bodyParameters: [String: String]? { nil }
    var customHeaders: [String: String]? { nil }
    var authorizationStrategy: AuthorizationStrategy? { nil }
    var timeoutInterval: TimeInterval? { 10 }
}
/*
#warning("I am thinking this part should be changed, look in the Ihor's project, he structed it well")
extension NetworkRequest {
    var urlRequest: URLRequest {
        guard let url = self.url else {
            #warning("is it expected behaviour :) ?")
            fatalError("Could not form URL")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        if let headers = customHeaders {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        return urlRequest
    }
    
    #warning("I don't like this approach overall")
    #warning("alamofire has methods for adding url parameteres, body parameters")
    private var url: URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = path
        
        if httpMethod == .get {
            if let parameters = queryParameters {
                urlComponents?.queryItems = parameters.map({URLQueryItem(name: $0.key, value: $0.value)})
            }
        }
        
        urlComponents?.queryItems?.append(URLQueryItem(name: "apiKey", value: "c5033dfeabae490e9e1cfc32e727eca0"))
        
        return urlComponents?.url
    }
}
*/
enum AuthorizationStrategy {
    case token
}

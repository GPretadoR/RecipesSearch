//
//  NetworkRequest.swift
//  MVVM-C-Networking
//
//  Created by Garnik Ghazaryan on 1/22/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import UIKit

protocol NetworkRequest {
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: String]? { get }
    var httpMethod: HTTPMethod { get }
    var customHeaders: [String: String]? { get }
}

extension NetworkRequest {
    var parameters: [String: String]? { nil }
    var customHeaders: [String: String]? { nil }
}

extension NetworkRequest {
    var urlRequest: URLRequest {
        guard let url = self.url else {
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
    
    private var url: URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = path
        
        if httpMethod == .get {
            if let parameters = parameters {
                urlComponents?.queryItems = parameters.map({URLQueryItem(name: $0.key, value: $0.value)})
            }
        }
        
        urlComponents?.queryItems?.append(URLQueryItem(name: "apiKey", value: "c5033dfeabae490e9e1cfc32e727eca0"))
        
        return urlComponents?.url
    }
}

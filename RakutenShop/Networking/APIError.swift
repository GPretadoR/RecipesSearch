//
//  APIError.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/10/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//
import Foundation

public struct APIError: LocalizedError {
    public let codeValue: String
    public let httpCode: Int
    
    public var errorDescription: String? {
        return "[\(httpCode)] \(codeValue)"
    }
}

public extension APIError {
    enum Code: String {
        case invalidErrorFormat = "invalid_error_format"
        case emptyData = "empty_data"
        
        case invalidJSON = "invalid_json"
        case missingData = "missing_data"
        case invalidCredentials = "invalid_credentials"
        case expiredCredentials = "expired_credentials"
        case userAlreadyHasPassword = "user_already_has_password"
        case accountLocked = "locked_user"
        
    }
    
    var code: Code? { Code(rawValue: codeValue) }
    
    init(code: Code, httpCode: Int) {
        self.init(codeValue: code.rawValue, httpCode: httpCode)
    }
}

public extension Error {
    var apiError: APIError? { self as? APIError }
}

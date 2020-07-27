//
//  RestError.swift
//
//  Created by Ivan Manov on 27.07.2020.
//  Copyright © 2020 @hellc. All rights reserved.
//

import Foundation

public struct CustomError: Error, Decodable {
    public var message: String?
    public var userMessage: String?
    public var code: String?
    public var status: String?
}

public enum RestError<CustomError>: Error {
    case noInternetConnection
    case custom(_ error: CustomError)
    case unauthorized
    case forbidden
    case other(_ message: String?)
    case unsupportedResource
}

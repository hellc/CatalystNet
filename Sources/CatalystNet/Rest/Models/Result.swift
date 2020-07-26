//
//  Result.swift
//
//  Created by Ivan Manov on 01.07.2020.
//  Copyright © 2020 @hellc. All rights reserved.
//

import Foundation

public struct CustomError: Error, Decodable {
    public var message: String
    public var userMessage: String
    public var code: String?
}

public enum Result<A, CustomError> {
    case success(A)
    case failure(RestError<CustomError>)
}

extension Result {
    public init(value: A?, or error: RestError<CustomError>) {
        guard let value = value else {
            self = .failure(error)
            return
        }

        self = .success(value)
    }

    public var value: A? {
        guard case let .success(value) = self else { return nil }
        return value
    }

    public var error: RestError<CustomError>? {
        guard case let .failure(error) = self else { return nil }
        return error
    }
}

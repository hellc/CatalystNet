//
//  ErrorConverter.swift
//
//  Created by Ivan Manov on 01.07.2020.
//  Copyright © 2020 @hellc. All rights reserved.
//

import Foundation

public struct ErrorConverter {
    public static func display(error: RestError<CustomError>?) -> String? {
        guard let error = error else { return nil }

        switch error {
        case .noInternetConnection:
            return "No internet connection"
        case .unauthorized:
            return "User unauthorized"
        case .other:
            return "Unknown error"
        case .forbidden:
            return "Resource forbidden"
        case .unsupportedResource:
            return "Resource deserialization error"
        case let .custom(error):
            return error.userMessage
        }
    }

    public static func code(error: RestError<CustomError>?) -> String? {
        guard let error = error else { return nil }

        switch error {
        case let .custom(error):
            if let code = error.code {
                return code
            }
        default: return nil
        }
        return nil
    }
}

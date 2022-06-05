//
//  CatalystError.swift
//
//  Created by Ivan Manov on 27.07.2020.
//  Copyright © 2020 @hellc. All rights reserved.
//

import Foundation

public enum CatalystError<E>: Error {
    case noInternetConnection
    case unauthorized
    case forbidden
    case other(_ message: String?)
    case unsupportedResource
    case custom(_ error: E?)
}

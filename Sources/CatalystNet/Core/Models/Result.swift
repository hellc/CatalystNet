//
//  Result.swift
//
//  Created by Ivan Manov on 01.07.2020.
//  Copyright © 2020 @hellc. All rights reserved.
//

import Foundation

public enum Result<A, E> {
    case success(A)
    case failure(CatalystError<E>)
}

extension Result {
    public init(value: A?, or error: CatalystError<E>) {
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

    public var error: CatalystError<E>? {
        guard case let .failure(error) = self else { return nil }
        return error
    }
}

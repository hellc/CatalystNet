//
//  Logs.swift
//
//  Created by Ivan Manov on 8/11/20.
//  Copyright © 2020 @hellc. All rights reserved.
//

import Foundation

public struct RequestLog {
    public let timestamp: Date
    public let httpMethod: String?
    public let headers: [AnyHashable: Any]?
    public let body: String?
    public let path: String?
    public let host: String?
    public let url: String?
}

public struct ResponseLog {
    public let timestamp: Date
    public let responseTime: TimeInterval?
    public let headers: [AnyHashable: Any]?
    public let body: String?
    public let code: Int?
}

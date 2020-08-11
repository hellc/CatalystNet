//
//  Logs.swift
//
//  Created by Ivan Manov on 8/11/20.
//  Copyright © 2020 @hellc. All rights reserved.
//

import Foundation

public struct RequestLog {
    let timestamp: Date
    let httpMethod: String?
    let headers: [AnyHashable: Any]?
    let body: String?
    let path: String?
    let host: String?
    let url: String?
}

public struct ResponseLog {
    let timestamp: Date
    let responseTime: TimeInterval?
    let headers: [AnyHashable: Any]?
    let body: String?
    let code: Int?
}
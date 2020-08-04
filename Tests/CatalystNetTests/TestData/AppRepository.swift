//
//  AppRepositoryExample.swift
//
//  Created by Ivan Manov on 01.07.2020.
//  Copyright © 2020 @hellc. All rights reserved.
//

import Foundation

enum Env: String {
    case dev = "https://jsonplaceholder.typicode.com"
    case test = "https://<path to test env>"
    case production = "https://<path to production env>"
}

class AppRepository {
    static let shared = AppRepository()
    
    var env: Env = .dev
    
    var baseUrl: String {
        return self.env.rawValue
    }
}

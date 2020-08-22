//
//  URLRequest+Init.swift
//
//  Created by Ivan Manov on 01.07.2020.
//  Copyright © 2020 @hellc. All rights reserved.
//

import Foundation

extension URLRequest {
    public init<A, E>(baseUrl: String, resource: Resource<A, E>) {
        let url = URL(baseUrl: baseUrl, resource: resource)
        
        self.init(url: url)
        
        httpMethod = resource.method.rawValue
        
        resource.headers.forEach {
            setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        switch resource.method {
        case .post, .put, .patch:
            switch resource.bodyFormat {
            case .multipartFormData:
                try? self.setMultipartFormData(resource.params, encoding: .utf8)
            default: // JSON
                httpBody = try! JSONSerialization.data(withJSONObject: resource.params, options: [])
            }
            
        default:
            break
        }
    }
}

//
//  ExampleApi.swift
//
//  Created by Ivan Manov on 26.05.2022.
//  Copyright © 2022 @hellc. All rights reserved.
//

import Foundation
@testable import CatalystNet

class ExampleApi: Api {
    private let client: HttpClient!
    
    init(baseUrl: String = "https://jsonplaceholder.typicode.com") {
        self.client = HttpClient(baseUrl: baseUrl)
    }
    
    func load<T, E>(_ resource: Resource<T, E>,
                    multitasking: Bool = false,
                    completion: @escaping (Result<T, E>) -> Void) {
        super.load(resource, self.client, multitasking: multitasking, completion: completion)
    }
}

@available(iOS 13.0.0, *)
@available(macOS 10.15.0, *)
extension ExampleApi {
    func load<T, E>(_ resource: Resource<T, E>) async throws -> T {
        return try await super.load(resource, self.client)
    }
}

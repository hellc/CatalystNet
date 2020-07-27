//
//  Resource.swift
//
//  Created by Ivan Manov on 01.07.2020.
//  Copyright © 2020 @hellc. All rights reserved.
//

import Foundation

public struct Resource<A, E> {
    let path: Path
    let parse: (Data) -> A?
    let parseError: (Data) -> E?
    
    public var method: RequestMethod
    public var headers: HTTPHeaders
    public var params: JSON

    public init(path: String,
         method: RequestMethod = .get,
         params: JSON = [:],
         headers: HTTPHeaders = [:],
         parse: @escaping (Data) -> A?,
         parseError: @escaping (Data) -> E?) {
        self.path = Path(path)
        self.method = method
        self.params = params
        self.headers = headers
        self.parse = parse
        self.parseError = parseError
    }
}

extension Resource where A: Decodable, E: Decodable {
    public init(jsonDecoder: JSONDecoder = JSONDecoder(),
         path: String,
         method: RequestMethod = .get,
         params: JSON = [:],
         headers: HTTPHeaders = [:]) {
        self.path = Path(path)
        self.method = method
        self.params = params
        self.headers = headers
        self.parse = {
            try? jsonDecoder.decode(A.self, from: $0)
        }
        self.parseError = {
            try? jsonDecoder.decode(E.self, from: $0)
        }
    }
}

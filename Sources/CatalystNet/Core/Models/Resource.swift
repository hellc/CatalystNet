//
//  Resource.swift
//
//  Created by Ivan Manov on 01.07.2020.
//  Copyright © 2020 @hellc. All rights reserved.
//

import Foundation

public enum BodyFormat {
    case json
    case multipartFormData
}

public struct CatalystFile {
    public var data: Data
    public var fileName: String
    public var mimeType: String
    public var fieldName: String
    
    public init(data: Data,
                fileName: String,
                mimeType: String,
                fieldName: String = "files") {
        self.data = data
        self.fileName = fileName
        self.mimeType = mimeType
        self.fieldName = fieldName
    }
}

public struct Resource<A, E> {
    let path: Path
    let parse: (Data) -> A?
    let parseError: (Data) -> E?
    
    public var method: RequestMethod
    public var headers: HTTPHeaders
    public var params: JSON
    public var queryParams: JSON
    public var bodyFormat: BodyFormat
    public var files: [CatalystFile]
    public var download: Bool

    public init(
        path: String,
        method: RequestMethod = .get,
        params: JSON = [:],
        queryParams: JSON = [:],
        headers: HTTPHeaders = [:],
        bodyFormat: BodyFormat = .json,
        files: [CatalystFile] = [],
        download: Bool = false,
        parse: @escaping (Data) -> A?,
        parseError: @escaping (Data) -> E?
    ) {
        self.path = Path(path)
        self.method = method
        self.params = params
        self.queryParams = queryParams
        self.headers = headers
        self.bodyFormat = bodyFormat
        self.files = files
        self.download = download
        
        self.parse = parse
        self.parseError = parseError
    }
}

extension Resource where A: Decodable, E: Decodable {
    public init(
        jsonDecoder: JSONDecoder = JSONDecoder(),
        path: String,
        method: RequestMethod = .get,
        params: JSON = [:],
        queryParams: JSON = [:],
        headers: HTTPHeaders = [:],
        bodyFormat: BodyFormat = .json,
        files: [CatalystFile] = [],
        download: Bool = false
    ) {
        self.path = Path(path)
        self.method = method
        self.params = params
        self.queryParams = queryParams
        self.headers = headers
        self.bodyFormat = bodyFormat
        self.files = files
        self.download = download
        
        self.parse = {
            try? jsonDecoder.decode(A.self, from: $0)
        }
        self.parseError = {
            try? jsonDecoder.decode(E.self, from: $0)
        }
    }
}

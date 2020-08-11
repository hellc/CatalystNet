//
//  WebClient.swift
//
//  Created by Ivan Manov on 01.07.2020.
//  Copyright © 2020 @hellc. All rights reserved.
//

import Foundation

public typealias JSON = [String: Any]
public typealias HTTPHeaders = [String: String]

public struct AnyResponse: Decodable {}

public enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

open class RestClient {
    private(set) var baseUrl: String
    
    public init(baseUrl: String) {
        self.baseUrl = baseUrl
    }

    public var commonParams: JSON = [:]

    // swiftlint:disable function_body_length
    open func load<A, E>(
        resource: Resource<A, E>,
        completion: @escaping (Result<Any, E>) -> Void,
        logging: Bool = false,
        logsHandler: @escaping (_ input: RequestLog, _ output: ResponseLog?) -> Void = { _, _ in }
    ) -> URLSessionDataTask? {
        #if !os(watchOS)
        if !Reachability.isConnectedToNetwork() {
            completion(.failure(.noInternetConnection))
            return nil
        }
        #endif

        var newResouce = resource

        newResouce.params += self.commonParams

        let request = URLRequest(baseUrl: baseUrl, resource: newResouce)

        var requestLog: RequestLog!
        
        if logging {
            requestLog = RequestLog(
                timestamp: Date(),
                httpMethod: request.httpMethod,
                headers: request.allHTTPHeaderFields,
                body: String(data: request.httpBody ?? Data(), encoding: .utf8),
                path: resource.path.absolutePath,
                host: self.baseUrl,
                url: request.url?.absoluteString
            )
        }

        
        let task = URLSession.shared.dataTask(with: request) { data, response, _ in
            // Parsing incoming data
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.other("HTTPURLResponse is missed")))
                return
            }
            
            let statusCode = response.statusCode
            let output = String(data: data ?? Data(), encoding: .utf8) ?? ""
            
            if logging {
                DispatchQueue.global().async {
                    let headers = response.allHeaderFields
                    let timestamp = Date()
                    let responseLog = ResponseLog(
                        timestamp: timestamp,
                        responseTime: timestamp.timeIntervalSince(requestLog.timestamp),
                        headers: headers,
                        body: output,
                        code: statusCode
                    )
                    
                    DispatchQueue.main.async {
                        logsHandler(requestLog, responseLog)
                    }
                }
            }
            
            if (200 ..< 300) ~= statusCode {
                if let value = data.flatMap(resource.parse) {
                    completion(Result(value: value, or: .other(output)))
                } else {
                    completion(Result(value: output, or: .unsupportedResource))
                }
            } else if statusCode == 401 {
                completion(.failure(.unauthorized))
            } else if statusCode == 403 {
                completion(.failure(.forbidden))
            } else if let error = data.flatMap(resource.parseError) {
                completion(.failure(.custom(error)))
            } else {
                completion(.failure(.other(output)))
            }
        }

        task.resume()

        return task
    }
}

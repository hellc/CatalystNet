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
    open func load<A, CustomError>(
        resource: Resource<A, CustomError>,
        completion: @escaping (Result<Any, CustomError>) -> Void,
        debug: Bool = false,
        responseHeaders: @escaping ([AnyHashable: Any]) -> Void = { _ in }
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

        let task = URLSession.shared.dataTask(with: request) { data, response, _ in
            
            // Parsing incoming data
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.other("HTTPURLResponse is missed")))
                return
            }
            
            let output = String(data: data ?? Data(), encoding: .utf8) ?? ""
            let headers = response.allHeaderFields
            
            if debug {
                print("📘 CatalystNet:", "\n📓 headers: \(headers)", "\n📗 output: \(output)")
            }
            
            responseHeaders(headers)
            
            if (200 ..< 300) ~= response.statusCode {
                if let value = data.flatMap(resource.parse) {
                    completion(Result(value: value, or: .other(output)))
                } else {
                    completion(Result(value: output, or: .unsupportedResource))
                }
            } else if response.statusCode == 401 {
                completion(.failure(.unauthorized))
            } else if response.statusCode == 403 {
                completion(.failure(.forbidden))
            } else {
                completion(.failure(data.flatMap(resource.parseError).map { .custom($0) } ?? .other(output)))
            }
        }

        task.resume()

        return task
    }
}

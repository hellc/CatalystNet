//
//  URLSession+Async.swift
//  
//
//  Created by Ivan Manov on 27.05.2022.
//

import Foundation

@available(iOS 13.0.0, *)
@available(iOS, deprecated: 15.0, message: "This extension is no longer necessary. Use API built into SDK")
@available(macOS 10.15.0, *)
@available(macOS, deprecated: 12.0, message: "This extension is no longer necessary. Use API built into SDK")
extension URLSession {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: url) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }
                
                continuation.resume(returning: (data, response))
            }
            
            task.resume()
        }
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }
                
                continuation.resume(returning: (data, response))
            }
            
            task.resume()
        }
    }
    
    func download(from url: URL) async throws -> (URL, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.downloadTask(with: url) { localURL, response, error in
                guard let localURL = localURL, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }
                
                continuation.resume(returning: (localURL, response))
            }
            
            task.resume()
        }
    }
    
    func download(for request: URLRequest) async throws -> (URL, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.downloadTask(with: request) { localURL, response, error in
                guard let localURL = localURL, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }
                
                continuation.resume(returning: (localURL, response))
            }
            
            task.resume()
        }
    }
}

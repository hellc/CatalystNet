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

// MARK: Output

extension RequestLog {
    public func formJsonOutput(with completion: @escaping (_ output: String?) -> Void) {
        DispatchQueue.global().async {
            var dict: [String: Any?] = [
                "Timestamp": self.timestamp.fullTimzoneDateToString(),
                "Url": self.url,
                "Base url": self.host,
                "Path": self.path,
                "Http Method": self.httpMethod,
                "Headers": self.headers,
                "Body": self.body
            ]
            
            dict = ["Request" : dict]

            var output: String?
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                output = String(data: jsonData, encoding: .utf8)
            } catch { }
            
            DispatchQueue.main.async {
                completion(output)
            }
        }
    }
}

extension ResponseLog {
    public func formJsonOutput(with completion: @escaping (_ output: String?) -> Void) {
        DispatchQueue.global().async {
            var dict: [String: Any?] = [
                "Timestamp": self.timestamp.fullTimzoneDateToString(),
                "Response Time": self.responseTime,
                "Code": self.code,
                "Headers": self.headers,
                "Body": self.body
            ]
            
            dict = ["Response" : dict]

            var output: String?
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                output = String(data: jsonData, encoding: .utf8)
            } catch { }
            
            DispatchQueue.main.async {
                completion(output)
            }
        }
    }
}

extension Date {
    func fullTimzoneDateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter.string(from: self)
    }
}

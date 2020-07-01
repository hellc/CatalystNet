//
//  Dictionary+Sugar.swift
//
//  Created by Ivan Manov on 01.07.2020.
//  Copyright © 2020 @hellc. All rights reserved.
//

import Foundation

public func += <K, V>(left: inout [K: V], right: [K: V]) {
    for (k, v) in right {
        left[k] = v
    }
}

extension Dictionary {
    public func hash() -> String {
        if let dict = self as? [String: Any] {
            let params = dict.sorted { $0.0 < $1.0 }
            let hash = (params.map { (pair) -> String in
                "\(pair.0)=\(pair.1)"
            }).joined(separator: "&")

            return hash
        }

        return ""
    }
}

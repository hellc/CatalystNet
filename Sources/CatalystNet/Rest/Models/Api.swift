//
//  Api.swift
//
//  Created by Ivan Manov on 01.07.2020.
//  Copyright © 2020 @hellc. All rights reserved.
//

import Foundation

open class Api {
    private(set) var tasks: [String: URLSessionDataTask] = [:]

    public init() {}
    
    public static func resource(_ resource: String, with id: String) -> String {
        return String.init(format: "%@/%@", resource, id)
    }
    
    public func killTasks() {
        self.tasks.values.forEach { task in
            task.cancel()
        }

        self.tasks.removeAll()
    }

    open func load<T>(_ resource: Resource<T, CustomError>,
                        _ client: RestClient,
                        multitasking: Bool = false,
                        completion: @escaping (Result<Any, CustomError>) -> Void) {
        DispatchQueue.main.async {
            let taskId = resource.path.absolutePath + resource.params.hash()

            if !multitasking, let task = self.tasks[taskId] {
                task.cancel()
                self.tasks.removeValue(forKey: taskId)
            }

            let task = client.load(
                resource: resource,
                completion: { response in
                    DispatchQueue.main.async {
                        completion(response.self)
                    }
                }
            )

            if !multitasking, let task = task {
                self.tasks.updateValue(task, forKey: taskId)
            }
        }
    }
}


//
//  Api.swift
//
//  Created by Ivan Manov on 01.07.2020.
//  Copyright © 2020 @hellc. All rights reserved.
//

import Foundation

open class Api {
    private(set) var tasks: [String: URLSessionTask] = [:]

    public init() {}
    
    public static func resource(_ location: String, with id: CVarArg) -> String {
        return "\(location)/\(id)"
    }
    
    public func killTasks() {
        self.tasks.values.forEach { task in
            task.cancel()
        }

        self.tasks.removeAll()
    }
    
    open func load<T, E>(_ resource: Resource<T, E>,
                        _ client: HttpClient,
                        multitasking: Bool = false,
                        completion: @escaping (Result<T, E>) -> Void) {
        self.load(
            resource,
            client,
            multitasking: multitasking,
            logging: true,
            logsHandler: { _, _ in }, completion: completion
        )
    }

    open func load<T, E>(_ resource: Resource<T, E>,
                        _ client: HttpClient,
                        multitasking: Bool = false,
                        logging: Bool = false,
                        logsHandler: @escaping (_ input: RequestLog, _ output: ResponseLog?) -> Void = { _, _ in },
                        completion: @escaping (Result<T, E>) -> Void) {
        DispatchQueue.main.async {
            let taskId = resource.path.absolutePath + resource.params.hash()

            if !multitasking, let task = self.tasks[taskId] {
                task.cancel()
                self.tasks.removeValue(forKey: taskId)
            }
            
            let task = client.load(resource: resource, completion: { response in
                DispatchQueue.main.async {
                    completion(response.self)
                }
            }, logging: logging, logsHandler: logsHandler)

            if !multitasking, let task = task {
                self.tasks.updateValue(task, forKey: taskId)
            }
        }
    }
}

@available(iOS 13.0.0, *)
@available(macOS 10.15.0, *)
extension Api {
    open func load<T, E>(_ resource: Resource<T, E>, _ client: HttpClient) async throws -> T {
        return try await client.load(resource: resource)
    }
}

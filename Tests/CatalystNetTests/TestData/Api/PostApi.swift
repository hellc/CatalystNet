//
//  File.swift
//  
//
//  Created by Ivan Manov on 05.06.2022.
//

import CatalystNet

class PostApi: ExampleApi {
    private struct Endpoints {
        static let posts = "/posts"
    }
    
    func post(with id: Int, completion: @escaping (Post?, CatalystError<CustomError>?) -> Void) {
        var resource = Resource<Post, CustomError>(path: Api.resource(Endpoints.posts, with: id))
        
        resource.method = .get
        
        self.load(resource) { response in
            switch response {
            case .success(let post):
                completion(post, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

@available(iOS 13.0.0, *)
@available(macOS 10.15.0, *)
extension PostApi {
    func post(with id: Int) async throws -> Post {
        var resource = Resource<Post, CustomError>(path: Api.resource(Endpoints.posts, with: id))
        
        resource.method = .get
        
        return try await self.load(resource)
    }
}

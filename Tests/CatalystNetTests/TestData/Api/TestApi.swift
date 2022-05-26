//
//  TestApi.swift
//
//  Created by Ivan Manov on 01.07.2020.
//  Copyright © 2020 @hellc. All rights reserved.
//

import Foundation
@testable import CatalystNet

class TestApi: Api {
    let client: HttpClient!
    
    struct Endpoints {
        static let posts = "/posts"
        
        static func photos(albumId: Int) -> String {
            return "/albums/\(albumId)/photos"
        }
        
        static func photo(albumId: Int, photoId: Int) -> String {
            return "/albums/\(albumId)/photos/\(photoId)"
        }
    }
    
    init(baseUrl: String) {
        self.client = HttpClient(baseUrl: baseUrl)
    }
    
    func load<T, E>(_ resource: Resource<T, E>,
                    multitasking: Bool = false,
                    completion: @escaping (Result<Any, E>) -> Void) {
        super.load(resource, self.client, multitasking: multitasking, completion: completion)
    }
    
    func post(with id: String, completion: @escaping (Post?, HttpError<String>?) -> Void) {
        var resource = Resource<Post, String>(path: Api.resource(Endpoints.posts, with: id))
        
        resource.method = .get
        
        self.load(resource) { response in
            if let post = response.value as? Post {
                completion(post, nil)
            } else {
                completion(nil, response.error)
            }
        }
    }
    
    func photos(with albumId: Int, completion: @escaping ([Photo]?, HttpError<String>?) -> Void) {
        var resource = Resource<[Photo], String>(path: Endpoints.photos(albumId: albumId))
        
        resource.method = .get
        
        self.load(resource) { response in
            if let photos = response.value as? [Photo] {
                completion(photos, nil)
            } else {
                completion(nil, response.error)
            }
        }
    }
    
    func photo(albumId: Int, photoId: Int, completion: @escaping (Photo?, HttpError<String>?) -> Void) {
        var resource = Resource<Photo, String>(path: Endpoints.photo(albumId: albumId, photoId: photoId))
        
        resource.method = .get
        
        self.load(resource) { response in
            if let photo = response.value as? Photo {
                completion(photo, nil)
            } else {
                completion(nil, response.error)
            }
        }
    }
}

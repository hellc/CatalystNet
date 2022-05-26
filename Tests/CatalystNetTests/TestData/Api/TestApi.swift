//
//  TestApi.swift
//
//  Created by Ivan Manov on 01.07.2020.
//  Copyright © 2020 @hellc. All rights reserved.
//

import Foundation
@testable import CatalystNet

class TestApi: Api {
    private let client: HttpClient!
    
    private struct Endpoints {
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
    
    @available(iOS 15.0, *)
    @available(macOS 10.15.0, *)
    @available(macOS 12.0, *)
    func load<T, E>(_ resource: Resource<T, E>) async -> Result<Any, E> {
        return await super.load(resource, self.client)
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
    
    @available(iOS 15.0, *)
    @available(macOS 10.15.0, *)
    @available(macOS 12.0, *)
    func post(with id: String) async -> (Post?, HttpError<String>?) {
        var resource = Resource<Post, String>(path: Api.resource(Endpoints.posts, with: id))
        
        resource.method = .get
        
        let response = await self.load(resource)
        
        if let post = response.value as? Post {
            return (post, nil)
        } else {
            return (nil, response.error)
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

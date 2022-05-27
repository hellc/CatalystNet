//
//  TestApiAsync.swift
//
//  Created by Ivan Manov on 26.05.2022.
//  Copyright © 2022 @hellc. All rights reserved.
//

import Foundation
@testable import CatalystNet

@available(iOS 13.0.0, *)
@available(macOS 10.15.0, *)
extension TestApi {
    func load<T, E>(_ resource: Resource<T, E>) async -> Result<Any, E> {
        return await super.load(resource, self.client)
    }
    
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
    
    func photos(with albumId: Int) async -> ([Photo]?, HttpError<String>?) {
        var resource = Resource<[Photo], String>(path: Endpoints.photos(albumId: albumId))
        
        resource.method = .get
        
        let response = await self.load(resource)
        
        if let photos = response.value as? [Photo] {
            return (photos, nil)
        } else {
            return (nil, response.error)
        }
    }
    
    
    func photo(photoId: Int) async -> (Photo?, HttpError<String>?) {
        var resource = Resource<Photo, String>(path: Endpoints.photo(photoId: photoId))
        
        resource.method = .get
        
        let response = await self.load(resource)
        
        if let photo = response.value as? Photo {
            return (photo, nil)
        } else {
            return (nil, response.error)
        }
    }
}

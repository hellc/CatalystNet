//
//  AlbumsApi.swift
//  
//
//  Created by Ivan Manov on 05.06.2022.
//

import CatalystNet

class AlbumsApi: ExampleApi {
    private struct Endpoints {
        static let albums: String = "/albums"
        static func photos(albumId: Int) -> String {
            return "\(Endpoints.albums)/\(albumId)/photos"
        }
    }
    
    func albums(completion: @escaping ([Album]?, CatalystError<CustomError>?) -> Void) {
        var resource = Resource<[Album], CustomError>(path: Endpoints.albums)
        
        resource.method = .get
        
        self.load(resource) { response in
            switch response {
            case .success(let albums):
                completion(albums, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func album(with id: Int, completion: @escaping (Album?, CatalystError<CustomError>?) -> Void) {
        var resource = Resource<Album, CustomError>(path: Api.resource(Endpoints.albums, with: id))
        
        resource.method = .get
        
        self.load(resource) { response in
            switch response {
            case .success(let album):
                completion(album, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func photos(albumId: Int, completion: @escaping ([Photo]?, CatalystError<CustomError>?) -> Void) {
        var resource = Resource<[Photo], CustomError>(path: Endpoints.photos(albumId: albumId))
        
        resource.method = .get
        
        self.load(resource) { response in
            switch response {
            case .success(let photos):
                completion(photos, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

@available(iOS 13.0.0, *)
@available(macOS 10.15.0, *)
extension AlbumsApi {
    func albums() async throws -> [Album] {
        var resource = Resource<[Album], CustomError>(path: Endpoints.albums)
        
        resource.method = .get
        
        return try await self.load(resource)
    }
    
    func album(with id: Int) async throws -> Album {
        var resource = Resource<Album, CustomError>(path: Api.resource(Endpoints.albums, with: id))
        
        resource.method = .get
        
        return try await self.load(resource)
    }
    
    func photos(albumId: Int) async throws -> [Photo] {
        var resource = Resource<[Photo], CustomError>(path: Endpoints.photos(albumId: albumId))
        
        resource.method = .get
        
        return try await self.load(resource)
    }
}

//
//  PhotosApi.swift
//  
//
//  Created by Ivan Manov on 05.06.2022.
//

import CatalystNet

class PhotosApi: ExampleApi {
    private struct Endpoints {
        static let photos: String = "/photos"
    }

    func photo(with id: Int, completion: @escaping (Photo?, CatalystError<CustomError>?) -> Void) {
        var resource = Resource<Photo, CustomError>(path: Api.resource(Endpoints.photos, with: id))
        
        resource.method = .get
        
        self.load(resource) { response in
            switch response {
            case .success(let photo):
                completion(photo, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

@available(iOS 13.0.0, *)
@available(macOS 10.15.0, *)
extension PhotosApi {
    func photo(with id: Int) async throws -> Photo {
        var resource = Resource<Photo, CustomError>(path: Api.resource(Endpoints.photos, with: id))
        
        resource.method = .get
        
        return try await self.load(resource)
    }
}

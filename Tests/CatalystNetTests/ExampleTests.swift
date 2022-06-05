//
//  TestApiTests.swift
//
//  Created by Ivan Manov on 01.07.2020.
//  Copyright © 2020 @hellc. All rights reserved.
//

import XCTest
@testable import CatalystNet

final class ExampleTests: XCTestCase {
    fileprivate let postApi = PostApi()
    fileprivate let albumsApi = AlbumsApi()
    fileprivate let photosApi = PhotosApi()
    
    func testPost() {
        let expectation = self.expectation(description: "Post")
        
        let id = 42
        self.postApi.post(with: id) { (post, error) in
            expectation.fulfill()
            
            if let post = post, error == nil {
                print(post)
            }
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testAlbumPhotos() {
        let expectation = self.expectation(description: "Photos")
        
        let albumId = 1
        self.albumsApi.photos(albumId: albumId) { (photos, error) in
            expectation.fulfill()
            
            guard let photos = photos, error == nil else {
                return
            }
            
            XCTAssertNotNil(photos)
            XCTAssertEqual(photos.count, 50, "First album photos count")
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPhoto() {
        let expectation = self.expectation(description: "Photo")
        
        let photoId: Int = 42
        self.photosApi.photo(with: photoId) { (photo, error) in
            expectation.fulfill()
            
            XCTAssertNotNil(photo)
            XCTAssertEqual(photo?.albumId, 1)
            XCTAssertEqual(photo?.id, 42)
            XCTAssertNotNil(photo?.url)
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }

    static var allTests = [
        ("testPost", testPost),
        ("testAlbumPhotos", testAlbumPhotos),
        ("testPhoto", testPhoto)
    ]
}

@available(iOS 13.0.0, *)
@available(macOS 10.15.0, *)
extension ExampleTests {
    func testPostAsync() async {
        let id = 42
        do {
            let post = try await self.postApi.post(with: id)
            XCTAssertNotNil(post)
            XCTAssertEqual(post.id, 42)
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testPhotosAsync() async {
        let albumId = 1
        
        do {
            let photos = try await self.albumsApi.photos(albumId: albumId)
            XCTAssertNotNil(photos)
            XCTAssertEqual(photos.count, 50, "First album photos count")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testPhotoAsync() async {
        let photoId = 42
        
        do {
            let photo = try await self.photosApi.photo(with: photoId)
            XCTAssertNotNil(photo)
            XCTAssertEqual(photo.albumId, 1)
            XCTAssertEqual(photo.id, 42)
            XCTAssertNotNil(photo.url)
            
            let photoUrl = photo.url
            XCTAssertNotNil(photoUrl)
            
            guard let urlString = photoUrl, let url = URL(string: urlString) else {
                return
            }
            XCTAssertNotNil(urlString)
            
            #if os(iOS)
            do {
                let (localUrl, _) = try await URLSession.shared.download(from: url)
                let imageDownloaded = UIImage(data: try Data(contentsOf: localUrl))
                
                XCTAssertNotNil(imageDownloaded)
                XCTAssertEqual(imageDownloaded?.size.height, 600)
                XCTAssertEqual(imageDownloaded?.size.width, 600)
                
                let (data, _) = try await URLSession.shared.data(from: url)
                let imageFromData = UIImage(data: data)
                XCTAssertNotNil(imageFromData)
                XCTAssertEqual(imageFromData?.size.height, 600)
                XCTAssertEqual(imageFromData?.size.width, 600)
            } catch {
                print(error)
                XCTAssertNotNil(error)
            }
            #endif
        } catch {
            XCTAssertNotNil(error)
        }
    }
}

//
//  TestApiTests.swift
//
//  Created by Ivan Manov on 01.07.2020.
//  Copyright © 2020 @hellc. All rights reserved.
//

import XCTest
@testable import CatalystNet

final class TestApiTests: XCTestCase {
    private let testApi = TestApi(baseUrl: "https://jsonplaceholder.typicode.com")
    
    func testPost() {
        let expectation = self.expectation(description: "Post")
        
        let id = "42"
        self.testApi.post(with: id) { (post, error) in
            expectation.fulfill()
            
            if let post = post, error == nil {
                print(post)
            }
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPhotos() {
        let expectation = self.expectation(description: "Photos")
        
        let albumId = 1
        self.testApi.photos(with: albumId) { (photos, error) in
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
        
        let photoId = 42
        self.testApi.photo(photoId: photoId) { (photo, error) in
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
        ("testPhotos", testPhotos),
        ("testPhoto", testPhoto)
    ]
}

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
    
    func testExample() {
        let expectation = self.expectation(description: "Post")
        
        let id = "42"
        self.testApi.post(with: id) { (post, error) in
            if let post = post, error == nil {
                print(post)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

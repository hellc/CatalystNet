//
//  TestApiAsyncTests.swift
//
//  Created by Ivan Manov on 26.05.2022.
//  Copyright © 2020 @hellc. All rights reserved.
//

import XCTest
@testable import CatalystNet

@available(iOS 15.0, *)
@available(macOS 10.15.0, *)
@available(macOS 12.0, *)
final class TestApiAsyncTests: XCTestCase {
    private let testApi = TestApi(baseUrl: "https://jsonplaceholder.typicode.com")
    
    func testAsync() async {
        let id = "42"
        let (post, error) = await self.testApi.post(with: id)
        
        XCTAssertNil(error)
        XCTAssertNotNil(post)
        XCTAssertEqual(post?.id, 42)
    }
}

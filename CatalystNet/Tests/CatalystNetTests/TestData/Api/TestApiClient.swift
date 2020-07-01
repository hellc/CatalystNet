//
//  TestApiClient.swift
//
//  Created by Ivan Manov on 01.07.2020.
//  Copyright © 2020 @hellc. All rights reserved.
//

import Foundation
@testable import CatalystNet

class TestApiClient: RestClient {
    static let shared = RestClient(baseUrl: AppRepository.shared.baseUrl)
}

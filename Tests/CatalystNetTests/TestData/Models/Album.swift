//
//  Album.swift
//
//
//  Created by Ivan Manov on 05.06.2022.
//

import Foundation

struct Album: Decodable {
    let userId: Int
    let id: Int
    let title: String?
}

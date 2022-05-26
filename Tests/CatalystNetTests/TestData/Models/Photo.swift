//
//  Photo.swift
//  
//
//  Created by Ivan Manov on 26.05.2022.
//

import Foundation

struct Photo: Decodable {
    let albumId: Int
    let id: Int
    let title: String?
    let url: String?
    let thumbnailUrl: String?
}

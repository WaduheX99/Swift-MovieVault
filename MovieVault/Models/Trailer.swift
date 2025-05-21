//
//  Trailer.swift
//  MovieVault
//
//  Created by Faza Faresha Affandi on 21/05/25.
//

import Foundation

struct TrailerResponse: Codable {
    let id: Int
    let results: [Trailer]
}

struct Trailer: Codable {
    let name: String
    let key: String
    let site: String
    let type: String
    let official: Bool
}

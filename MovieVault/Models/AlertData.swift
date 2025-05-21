//
//  AlertData.swift
//  MovieVault
//
//  Created by Faza Faresha Affandi on 21/05/25.
//

import Foundation

struct AlertData: Codable {
    let statusCode: Int
    let statusMessage: String

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

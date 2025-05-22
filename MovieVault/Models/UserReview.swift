//
//  UserReview.swift
//  MovieVault
//
//  Created by Faza Faresha Affandi on 21/05/25.
//

import Foundation

struct UserReviewResponse: Codable {
    let id: Int
    let results: [UserReview]
}

struct UserReview: Codable, Identifiable {
    let id: String
    let author: String
    let content: String
    let authorDetails: AuthorDetails

    enum CodingKeys: String, CodingKey {
        case id, author, content
        case authorDetails = "author_details"
    }

    struct AuthorDetails: Codable {
        let name: String?
        let username: String?
        let rating: Double?
        let avatarPath: String?

        enum CodingKeys: String, CodingKey {
            case name, username, rating
            case avatarPath = "avatar_path"
        }
    }
}


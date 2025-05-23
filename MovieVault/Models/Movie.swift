//
//  Movie.swift
//  MovieVault
//
//  Created by Faza Faresha Affandi on 21/05/25.
//

import Foundation

struct MovieResponse: Decodable {
    let page: Int
    let results: [Movie]
}

struct Movie: Decodable, Encodable, Identifiable, Equatable {
    let adult: Bool
    let backdropPath: String?
    let genreIDs: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension Movie {
    var genreNames: [String] {
        genreIDs.compactMap { GenreHelper.genreMap[$0] }
    }
}

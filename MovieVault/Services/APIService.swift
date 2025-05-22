//
//  APIService.swift
//  MovieVault
//
//  Created by Faza Faresha Affandi on 21/05/25.
//

import Foundation
import Alamofire
import RxSwift

protocol APIService {
    func fetchMovies(for category: MovieListCategory) -> Observable<[Movie]>
    func fetchMovieTrailer(movieId: Int) -> Observable<[Trailer]>
    func fetchMovieReviews(movieId: Int) -> Observable<[UserReview]>
}

class APIServiceImpl : APIService {
    func fetchPopularFilms() -> Observable<[Movie]> {
        let response : Observable<MovieResponse?> = HttpHelper.request("/movie/popular", method: .get)
        
        return response.map { movieResponse in
            guard let movieResponse = movieResponse else { return [] }
            return movieResponse.results
        }
    }
    
    func fetchMovies(for category: MovieListCategory) -> Observable<[Movie]> {
        let response: Observable<MovieResponse?> = HttpHelper.request(category.endpoint, method: .get)
        
        return response.map { movieResponse in
            guard let movieResponse = movieResponse else { return [] }
            return movieResponse.results
        }
    }
    
    func fetchMovieTrailer(movieId: Int) -> Observable<[Trailer]> {
        let endpoint = "/movie/\(movieId)/videos"
        let response: Observable<TrailerResponse?> = HttpHelper.request(endpoint, method: .get)
        
        return response.map { trailerResponse in
            guard let trailerResponse = trailerResponse else { return [] }
            return trailerResponse.results
                .filter { $0.site.lowercased() == "youtube" && $0.type.lowercased() == "trailer" }
        }
    }
    
    func fetchMovieReviews(movieId: Int) -> Observable<[UserReview]> {
        let endpoint = "/movie/\(movieId)/reviews"
        let response: Observable<UserReviewResponse?> = HttpHelper.request(endpoint, method: .get)
        
        return response.map { $0?.results.prefix(5).map { $0 } ?? [] }
    }
}


enum MovieListCategory {
    case popular
    case nowPlaying
    case topRated
    case trendingWeekly
    
    var endpoint: String {
        switch self {
        case .popular: return "/movie/popular"
        case .nowPlaying: return "/movie/now_playing"
        case .topRated: return "/movie/top_rated"
        case .trendingWeekly: return "/trending/movie/week"
        }
    }
}

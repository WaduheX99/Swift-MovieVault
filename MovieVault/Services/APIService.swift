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
    func fetchMoviesByCategory(for category: MovieListCategory) -> Observable<[Movie]>
    func fetchAllMovies(page: Int) -> Observable<[Movie]>
    func fetchMovieTrailer(movieId: Int) -> Observable<[Trailer]>
    func fetchMovieReviews(movieId: Int) -> Observable<[UserReview]>
    func searchMovies(query: String) -> Observable<[Movie]>
}

class APIServiceImpl : APIService {    
    func fetchAllMovies(page: Int) -> Observable<[Movie]> {
        let endpoint = "/movie/popular?page=\(page)&"
        let response: Observable<MovieResponse?> = HttpHelper.request(endpoint, method: .get)
        
        return response.map { movieResponse in
            guard let movieResponse = movieResponse else { return [] }
            return movieResponse.results
        }
    }
    
    func fetchMoviesByCategory(for category: MovieListCategory) -> Observable<[Movie]> {
        let response: Observable<MovieResponse?> = HttpHelper.request(category.endpoint, method: .get)
        
        return response.map { movieResponse in
            guard let movieResponse = movieResponse else { return [] }
            return movieResponse.results
        }
    }
    
    func fetchMovieTrailer(movieId: Int) -> Observable<[Trailer]> {
        let endpoint = "/movie/\(movieId)/videos?"
        let response: Observable<TrailerResponse?> = HttpHelper.request(endpoint, method: .get)
        
        return response.map { trailerResponse in
            guard let trailerResponse = trailerResponse else { return [] }
            return trailerResponse.results
                .filter { $0.site.lowercased() == "youtube" && $0.type.lowercased() == "trailer" }
        }
    }
    
    func fetchMovieReviews(movieId: Int) -> Observable<[UserReview]> {
        let endpoint = "/movie/\(movieId)/reviews?"
        let response: Observable<UserReviewResponse?> = HttpHelper.request(endpoint, method: .get)
        
        return response.map { reviewResponse in
            guard let reviewResponse = reviewResponse else { return [] }
            return reviewResponse.results
        }
    }
    
    func searchMovies(query: String) -> Observable<[Movie]> {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let endpoint = "/search/movie?query=\(encodedQuery)&"
        
        let response: Observable<MovieResponse?> = HttpHelper.request(endpoint, method: .get)
        
        return response.map { searchResponse in
            guard let searchResponse = searchResponse else { return [] }
            return searchResponse.results
        }
    }
}


enum MovieListCategory {
    case popular
    case nowPlaying
    case topRated
    case trendingWeekly
    case upcoming
    
    var endpoint: String {
        switch self {
        case .popular: return "/movie/popular?"
        case .nowPlaying: return "/movie/now_playing?"
        case .topRated: return "/movie/top_rated?"
        case .trendingWeekly: return "/trending/movie/week?"
        case .upcoming: return "/movie/upcoming?"
        }
    }
}

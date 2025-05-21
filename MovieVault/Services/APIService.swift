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
    func fetchPopularFilms() -> Observable<[Movie]>
    func fetchMovieTrailers(movieId: Int) -> Observable<[Trailer]>

}

class APIServiceImpl : APIService {
    func fetchPopularFilms() -> Observable<[Movie]> {
        let response : Observable<MovieResponse?> = HttpHelper.request("/movie/popular", method: .get)
        
        return response.map { movieResponse in
            guard let movieResponse = movieResponse else { return [] }
            return movieResponse.results
        }
    }
    
    func fetchMovieTrailers(movieId: Int) -> Observable<[Trailer]> {
        let endpoint = "/movie/\(movieId)/videos"
        let response: Observable<TrailerResponse?> = HttpHelper.request(endpoint, method: .get)
        
        return response.map { trailerResponse in
            guard let trailerResponse = trailerResponse else { return [] }
            return trailerResponse.results
                .filter { $0.site.lowercased() == "youtube" && $0.type.lowercased() == "trailer" }
        }
    }
    
}

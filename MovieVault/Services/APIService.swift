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
}

class APIServiceImpl : APIService {
    func fetchPopularFilms() -> Observable<[Movie]> {
        let response : Observable<MovieResponse?> = HttpHelper.request("/movie/popular", method: .get)
        
        return response.map { movieResponse in
            guard let movieResponse = movieResponse else { return [] }
            return movieResponse.results
        }
    }
    
}

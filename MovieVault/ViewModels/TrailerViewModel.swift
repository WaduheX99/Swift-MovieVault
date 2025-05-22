//
//  TrailerViewModel.swift
//  MovieVault
//
//  Created by Faza Faresha Affandi on 21/05/25.
//

import Foundation
import RxSwift

class TrailerViewModel: ObservableObject {
    @Published var trailers: [Trailer] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let movieService: APIService
    private let disposeBag = DisposeBag()
    
    init(movieService: APIService) {
        self.movieService = movieService
    }
    
    func fetchMovieTrailer(id: Int) {
        isLoading = true
        movieService.fetchMovieTrailer(movieId: id)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] trailers in
                    self?.trailers = trailers
                    self?.isLoading = false
                },
                onError: { [weak self] error in
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                }
            )
            .disposed(by: disposeBag)
    }
}

//
//  UserReviewViewModel.swift
//  MovieVault
//
//  Created by Faza Faresha Affandi on 21/05/25.
//

import Foundation
import RxSwift

class UserReviewViewModel: ObservableObject {
    @Published var reviews: [UserReview] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let movieService: APIService
    private var disposeBag = DisposeBag()

    init(movieService: APIService) {
        self.movieService = movieService
    }

    func fetchMovieReviews(id: Int) {
        isLoading = true
        movieService.fetchMovieReviews(movieId: id)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] reviews in
                self?.reviews = reviews
                self?.isLoading = false
            }, onError: { [weak self] error in
                self?.errorMessage = error.localizedDescription
                self?.isLoading = false
            })
            .disposed(by: disposeBag)
    }
}

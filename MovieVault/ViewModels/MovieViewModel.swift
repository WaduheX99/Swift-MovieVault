//
//  MovieViewModel.swift
//  MovieVault
//
//  Created by Faza Faresha Affandi on 21/05/25.
//

import Foundation
import RxSwift

class MovieViewModel : ObservableObject {
    
    private var movieService: APIService
    private var disposeBag: DisposeBag = DisposeBag()
    
    @Published var popularMovieList: [Movie] = []
    
    @Published var failedFetchMessage: String?
    @Published var successMessage: String?
    @Published var showAlert: Bool = false
    @Published var alertData: AlertData?
    
    @Published var isLoading: Bool = true
    
    init(movieService: APIService) {
        self.movieService = movieService
    }
    
    func fetchPopularFilms(page: Int = 0, limit: Int = 0){
        movieService.fetchPopularFilms()
            .do(
                onSubscribe: { [weak self] in
                    self?.isLoading = true
                },
                onDispose: { [weak self] in
                    self?.isLoading = false
                }
            )
            .subscribe(
                onNext: { [weak self] (list : [Movie]?) in
                    guard let list else { return }
                    self?.popularMovieList = list
                    self?.failedFetchMessage = nil
                },
                onError: { error in
                    if let nsError = error as NSError?{
                        if nsError.code == 401 {
                            print("Status code: \(nsError.code)")
                            self.alertData = AlertData(
                                statusCode: nsError.code,
                                statusMessage: nsError.localizedDescription
                            )
                            self.showAlert = true
                        }
                        else {
                            self.failedFetchMessage = nsError.domain
                        }
                    }
                }
            )
            .disposed(by: disposeBag)
    }
}

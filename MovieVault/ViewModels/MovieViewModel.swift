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
    @Published var nowPlayingList: [Movie] = []
    @Published var topRatedList: [Movie] = []
    @Published var trendingWeeklyList: [Movie] = []
    @Published var upcomingList: [Movie] = []
    @Published var allMovies: [Movie] = []
    @Published var searchResults: [Movie] = []
    
    @Published var failedFetchMessage: String?
    @Published var successMessage: String?
    @Published var showAlert: Bool = false
    @Published var alertData: AlertData?
    
    @Published var isLoading: Bool = true
    
    init(movieService: APIService) {
        self.movieService = movieService
    }
    
    private var currentPage = 2
    private var isLoadingMore = false

    func fetchMoviesByCategory(for category: MovieListCategory) {
        movieService.fetchMoviesByCategory(for: category)
            .do(
                onSubscribe: { [weak self] in
                    self?.isLoading = true
                },
                onDispose: { [weak self] in
                    self?.isLoading = false
                }
            )
            .subscribe(onNext: { [weak self] list in
                guard let self else { return }
                switch category {
                case .popular:
                    self.popularMovieList = list
                case .nowPlaying:
                    self.nowPlayingList = list
                case .topRated:
                    self.topRatedList = list
                case .trendingWeekly:
                    self.trendingWeeklyList = list
                case .upcoming:
                    self.upcomingList = list
                }
            }, onError: { [weak self] error in
                self?.handleError(error)
            })
           .disposed(by: disposeBag)
    }

    func fetchAllMoviesNextPage() {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        isLoading = true

        movieService.fetchAllMovies(page: currentPage)
            .subscribe(onNext: { [weak self] newMovies in
                guard let self = self else { return }
                self.allMovies.append(contentsOf: newMovies)
                self.currentPage += 1
                self.isLoadingMore = false
                self.isLoading = false
            }, onError: { [weak self] error in
                self?.handleError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func searchMovies(by query: String) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.searchResults = []
            return
        }
        
        movieService.searchMovies(query: query)
            .subscribe(onNext: { [weak self] results in
                self?.searchResults = results
            }, onError: { [weak self] error in
                self?.handleError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func clearSearchResults() {
        self.searchResults = []
    }

    
    //MARK: HANDLE ERROR
    private func handleError(_ error: Error) {
        if let nsError = error as NSError? {
            if nsError.code == 401 {
                self.alertData = AlertData(statusCode: nsError.code, statusMessage: nsError.localizedDescription)
                self.showAlert = true
            } else {
                self.failedFetchMessage = nsError.domain
            }
        }
    }
}

//
//  MainView.swift
//  MovieVault
//
//  Created by Faza Faresha Affandi on 21/05/25.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel = MovieViewModel(movieService: APIServiceImpl())
    
    @State private var movies: [Movie] = []
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    
                    // Section: Popular
                    MovieCategorySection(title: "Popular", movies: viewModel.popularMovieList)

                    // Section: Now Playing
                    MovieCategorySection(title: "Now Playing", movies: viewModel.nowPlayingList)
                    
                    // Section: Top Rated
                    MovieCategorySection(title: "Top Picks", movies: viewModel.topRatedList)
                    
                    // Section: Trending This Week
                    MovieCategorySection(title: "Weekly Trending", movies: viewModel.trendingWeeklyList)
                }
                .padding(.vertical)
            }
            .navigationTitle("Movie Vault")
            .onAppear {
                viewModel.fetchMovies(for: .popular)
                viewModel.fetchMovies(for: .nowPlaying)
                viewModel.fetchMovies(for: .topRated)
                viewModel.fetchMovies(for: .trendingWeekly)
            }
            .refreshable {
                viewModel.fetchMovies(for: .popular)
                viewModel.fetchMovies(for: .nowPlaying)
                viewModel.fetchMovies(for: .topRated)
                viewModel.fetchMovies(for: .trendingWeekly)
            }
        }
    }
}

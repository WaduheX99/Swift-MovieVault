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
    @State private var isSearching = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    
                    // Big Carousel
                    if !viewModel.popularMovieList.isEmpty {
                        BigMovieCarousel(movies: Array(viewModel.popularMovieList.shuffled().prefix(5)))
                            .frame(height: 450)
                    }

                    
                    // Section: Now Playing
                    MovieCategorySection(title: "Now Playing", movies: viewModel.nowPlayingList)
                        .padding(.top, 60)
                    
                    // Section: Popular
                    MovieCategorySection(title: "Popular", movies: viewModel.popularMovieList)
                    
                    // Section: Top Rated
                    MovieCategorySection(title: "Top Picks", movies: viewModel.topRatedList)
                    
                    // Section: Trending This Week
                    MovieCategorySection(title: "Weekly Trending", movies: viewModel.trendingWeeklyList)
                    
                    // Section : Discover More
                    AllMoviesSection(viewModel: viewModel)
                }
                
                NavigationLink(destination: SearchView(viewModel: viewModel),
                               isActive: $isSearching) {
                    EmptyView()
                }
                .hidden()

            }
            .background(Color.clear)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("MV")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color(.orange))
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isSearching = true
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundColor(Color(.orange))
                    }
                }
            }


            .onAppear {
                viewModel.fetchMoviesByCategory(for: .popular)
                viewModel.fetchMoviesByCategory(for: .nowPlaying)
                viewModel.fetchMoviesByCategory(for: .topRated)
                viewModel.fetchMoviesByCategory(for: .trendingWeekly)
                viewModel.fetchAllMoviesNextPage()

            }
            .refreshable {
                viewModel.fetchMoviesByCategory(for: .popular)
                viewModel.fetchMoviesByCategory(for: .nowPlaying)
                viewModel.fetchMoviesByCategory(for: .topRated)
                viewModel.fetchMoviesByCategory(for: .trendingWeekly)
                viewModel.fetchAllMoviesNextPage()

            }
        }
    }
}

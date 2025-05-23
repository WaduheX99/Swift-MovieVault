//
//  MainView.swift
//  MovieVault
//
//  Created by Faza Faresha Affandi on 21/05/25.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var networkMonitor = NetworkHelper()
    @StateObject var viewModel = MovieViewModel(movieService: APIServiceImpl())
    
    @State private var movies: [Movie] = []
    @State private var errorMessage: String?
    @State private var isSearching = false

    var body: some View {
        NavigationView {
            Group{
                if networkMonitor.isConnected {
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
                            
                            // Section: Top Rated
                            MovieCategorySection(title: "Top Picks", movies: viewModel.topRatedList)
                            
                            // Section: Trending This Week
                            MovieCategorySection(title: "Weekly Trending", movies: viewModel.trendingWeeklyList)
                            
                            // Section: Upcoming
                            MovieCategorySection(title: "Upcoming", movies: viewModel.upcomingList)
                            
                            // Section : Discover More
                            AllMoviesSection(viewModel: viewModel)
                        }
                        
                        NavigationLink(destination: SearchView(viewModel: viewModel),
                                       isActive: $isSearching) {
                            EmptyView()
                        }
                        .hidden()
                        
                        

                    }
                }
                else {
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: "wifi.slash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color(.orange))

                        Text("You're offline")
                            .font(.title2.bold())

                        Text("Turn on mobile data or connect to a Wi-Fi")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .background(Color.clear)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("MV_Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isSearching = true
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.title2.bold())
                            .foregroundColor(Color(.orange))
                    }
                }
            }
            .onAppear {
                fetchContents()
            }
            .refreshable {
                fetchContents()
            }
        }
    }
    
    private func fetchContents() {
        viewModel.fetchMoviesByCategory(for: .popular)
        viewModel.fetchMoviesByCategory(for: .nowPlaying)
        viewModel.fetchMoviesByCategory(for: .topRated)
        viewModel.fetchMoviesByCategory(for: .trendingWeekly)
        viewModel.fetchMoviesByCategory(for: .upcoming)
        viewModel.fetchAllMoviesNextPage()
    }
}

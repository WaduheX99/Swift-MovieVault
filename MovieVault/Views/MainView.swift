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
            List(viewModel.popularMovieList) { movie in
                NavigationLink(destination: DetailMovieView(movie: movie)) {
                    HStack(alignment: .top) {
                        if let posterPath = movie.posterPath,
                           let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 60, height: 90)
                            .cornerRadius(8)
                        }

                        VStack(alignment: .leading, spacing: 5) {
                            Text(movie.title)
                                .font(.headline)
                            Text(movie.releaseDate)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Trending Now")
            .onAppear {
                viewModel.fetchPopularFilms()
            }
            .refreshable {
                viewModel.fetchPopularFilms()
            }
        }
    }
}

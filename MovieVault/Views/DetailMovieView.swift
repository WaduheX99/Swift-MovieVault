//
//  DetailMovieView.swift
//  MovieVault
//
//  Created by Faza Faresha Affandi on 21/05/25.
//

import SwiftUI

struct DetailMovieView: View {
    let movie: Movie
    
    @StateObject var trailerViewModel = TrailerViewModel(movieService: APIServiceImpl())

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                if let backdrop = movie.backdropPath,
                   let url = URL(string: "https://image.tmdb.org/t/p/w780\(backdrop)") {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Release Year: \(String(movie.releaseDate.prefix(4)))")
                        .font(.subheadline)

                    Text("Rating: \(String(format: "%.1f", movie.voteAverage)) (\(movie.voteCount) votes)")
                        .font(.subheadline)

                    if !movie.genreIDs.isEmpty {
                        Text("Genres: \(movie.genreIDs.map { String($0) }.joined(separator: ", "))")
                            .font(.subheadline)
                    }

                    Text(movie.overview)
                        .font(.body)
                        .padding(.top)
                }
                .padding(.horizontal)
                
                if trailerViewModel.isLoading {
                    ProgressView()
                } else if let trailer = trailerViewModel.trailers.first,
                          let url = URL(string: "https://www.youtube.com/embed/\(trailer.key)") {
                    WebView(url: url)
                        .frame(height: 200)
                        .cornerRadius(8)
                        .padding(.horizontal)
                } else {
                    Text("Trailer tidak tersedia.")
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
            }
        }
        .onAppear {
            trailerViewModel.fetchTrailerfromID(id: movie.id)
        }
        .refreshable {
            trailerViewModel.fetchTrailerfromID(id: movie.id)
        }
        .navigationTitle("Movie Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

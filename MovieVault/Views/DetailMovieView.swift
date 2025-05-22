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
    @StateObject private var reviewViewModel = UserReviewViewModel(movieService: APIServiceImpl())

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

                    if !movie.genreNames.isEmpty {
                        Text("Genres: \(movie.genreNames.joined(separator: ", "))")
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
                
                if reviewViewModel.isLoading {
                    ProgressView()
                        .frame(height: 150)
                } else if reviewViewModel.reviews.isEmpty {
                    Text("No reviews available")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(reviewViewModel.reviews.indices, id: \.self) { index in
                                let review = reviewViewModel.reviews[index]
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("⭐️ \(review.authorDetails.rating ?? 0.0, specifier: "%.1f")")
                                        .font(.subheadline)
                                    Text("by \(review.author)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(review.content)
                                        .lineLimit(6)
                                        .font(.body)
                                }
                                .padding()
                                .frame(width: 300)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .onAppear {
            trailerViewModel.fetchMovieTrailer(id: movie.id)
            reviewViewModel.fetchMovieReviews(id: movie.id)
        }
        .refreshable {
            trailerViewModel.fetchMovieTrailer(id: movie.id)
            reviewViewModel.fetchMovieReviews(id: movie.id)
        }
        .navigationTitle("Movie Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

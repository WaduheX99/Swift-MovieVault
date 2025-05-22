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

    @State private var showTrailerPlayer: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: - Trailer Preview with Inline Playback
                ZStack {
                    if showTrailerPlayer,
                       let trailer = trailerViewModel.trailers.first,
                       let trailerURL = URL(string: "https://www.youtube.com/embed/\(trailer.key)?autoplay=1&playsinline=1&modestbranding=1&showinfo=0&controls=1") {

                        WebView(url: trailerURL)
                            .frame(height: 220)
                            .cornerRadius(12)
                            .padding(.horizontal)

                    } else {
                        if let backdrop = movie.backdropPath,
                           let url = URL(string: "https://image.tmdb.org/t/p/w780\(backdrop)") {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                Rectangle()
                                    .foregroundColor(.gray.opacity(0.3))
                            }
                        }

                        if !trailerViewModel.trailers.isEmpty {
                            Button(action: {
                                showTrailerPlayer = true
                            }) {
                                Text("▶︎ Watch Trailer")
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.white.opacity(0.85))
                                    .foregroundColor(.black)
                                    .clipShape(Capsule())
                                    .shadow(radius: 4)
                            }
                        } else {
                            Text("Trailer tidak tersedia")
                                .foregroundColor(.secondary)
                        }
                    }
                }

                // MARK: - Title, Duration & Year
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.title)
                        .bold()
                    
                    Text(movie.releaseDate.prefix(4))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                }
                .padding(.horizontal)

                // MARK: - Genres
                if !movie.genreNames.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(movie.genreNames, id: \.self) { genre in
                                Text(genre)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Capsule())
                                    .font(.caption)
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                // MARK: - Overview Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Overview")
                        .font(.headline)

                    Text(movie.overview)
                        .font(.caption)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal)

                // MARK: - Rating & Reviews
                VStack(alignment: .leading, spacing: 12) {
                    Text("User Review")
                        .font(.headline)
                        .padding(.horizontal)

                    // ⭐️ Rating besar
                    VStack(alignment: .leading, spacing: 4) {
                        Text("⭐️ \(movie.voteAverage, specifier: "%.1f")")
                            .font(.system(size: 36, weight: .bold))

                        Text("\(movie.voteCount) total votes")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)

                    Text("Featured Reviews")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)

                    // Review Cards
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
                                ForEach(reviewViewModel.reviews.prefix(5), id: \.id) { review in
                                    VStack(alignment: .leading, spacing: 8) {
                                        // Konten komentar
                                        Text(review.content)
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                            .lineLimit(5)
                                            .truncationMode(.tail)
                                            .frame(maxHeight: .infinity, alignment: .topLeading)

                                        Spacer()

                                        HStack {
                                            Text("by \(review.author)")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)

                                            Spacer()

                                            Text("⭐️ \(review.authorDetails.rating ?? 0.0, specifier: "%.1f")")
                                                .font(.footnote)
                                                .foregroundColor(.primary)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color.yellow.opacity(0.15))
                                                .clipShape(Capsule())
                                        }
                                    }
                                    .padding()
                                    .frame(width: 240, height: 160)
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                }

                            }
                            .padding(.horizontal)
                        }
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


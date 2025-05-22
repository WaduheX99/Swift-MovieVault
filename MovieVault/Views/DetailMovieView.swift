//
//  DetailMovieView.swift
//  MovieVault
//
//  Created by Faza Faresha Affandi on 21/05/25.
//

import SwiftUI

struct DetailMovieView: View {
    @Environment(\.dismiss) var dismiss
    
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

                // MARK: - Title & Year
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
                VStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.orange))
                                .frame(width: 4)
                                .frame(maxHeight: .infinity)
                            
                            Text("Overview")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        Text(movie.overview)
                            .font(.footnote)
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 20)

                // MARK: - Rating & Reviews
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.orange))
                            .frame(width: 4)
                            .frame(maxHeight: .infinity)
                            .padding(.top, 2)
                        
                        Text("User Reviews")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Spacer()

                        VStack(spacing: 6) {
                            HStack(alignment: .firstTextBaseline, spacing: 2) {
                                Text("⭐️")
                                    .font(.system(size: 32))
                                Text(formatRating(movie.voteAverage))
                                    .font(.system(size: 32, weight: .bold))
                                Text("/ 10")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                            }

                            Text("\(movie.voteCount) Votes")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()
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

                                            Text("⭐️ \(formatRating(review.authorDetails.rating ?? 0.0))")
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
                .padding(.top, 20)
                
            }
            .padding(.bottom, 50)
        }
        .onAppear {
            trailerViewModel.fetchMovieTrailer(id: movie.id)
            reviewViewModel.fetchMovieReviews(id: movie.id)
        }
        .refreshable {
            trailerViewModel.fetchMovieTrailer(id: movie.id)
            reviewViewModel.fetchMovieReviews(id: movie.id)
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    // MARK: Decimal Converter (, to .)
    func formatRating(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

}


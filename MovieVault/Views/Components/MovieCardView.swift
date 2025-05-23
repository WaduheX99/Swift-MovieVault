//
//  MovieCardView.swift
//  MovieVault
//
//  Created by Faza Faresha Affandi on 22/05/25.
//

import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    let width: CGFloat

    var body: some View {
        NavigationLink(destination: DetailMovieView(movie: movie)) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .bottomLeading) {
                    if let posterPath = movie.posterPath,
                       let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: width, height: width * 1.5)
                                .clipped()
                                .cornerRadius(12)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: width, height: width * 1.5)
                                .cornerRadius(12)
                        }
                    } else {
                        ZStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: width, height: width * 1.5)
                                .cornerRadius(12)
                            Text("Poster not found")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(String(format: "%.1f", movie.voteAverage))
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.6))
                    .clipShape(Capsule())
                    .padding(8)
                }

                Text(movie.title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .frame(height: 40, alignment: .top)
            }
            .frame(width: width)
            .alignmentGuide(.top) { _ in 0 }
        }
        .buttonStyle(PlainButtonStyle())
    }
}





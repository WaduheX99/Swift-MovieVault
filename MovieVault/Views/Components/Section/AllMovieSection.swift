//
//  AllMovieSection.swift
//  MovieVault
//
//  Created by Faza Faresha Affandi on 22/05/25.
//

import SwiftUI

struct AllMoviesSection: View {
    @ObservedObject var viewModel: MovieViewModel

    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 16), count: 3)
    let spacing: CGFloat = 16
    let horizontalPadding: CGFloat = 16

    var cardWidth: CGFloat {
        let totalSpacing = spacing * 2
        let totalPadding = horizontalPadding * 2
        let availableWidth = UIScreen.main.bounds.width - totalSpacing - totalPadding
        return availableWidth / 3
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.orange))
                    .frame(width: 4)
                    .frame(maxHeight: .infinity)
                
                Text("Discover More")
                    .font(.title2)
                    .bold()
            }
            .padding(.horizontal)

            LazyVGrid(columns: columns, spacing: spacing) {
                let movies = paddedMovies()

                ForEach(movies.indices, id: \.self) { index in
                    if let movie = movies[index] {
                        MovieCardView(movie: movie, width: cardWidth)
                            .frame(height: 250)
                            .onAppear {
                                if movie == viewModel.allMovies.last {
                                    viewModel.fetchAllMoviesNextPage()
                                }
                            }
                    } else {
                        Color.clear
                            .frame(width: cardWidth, height: 250)
                    }
                }
            }
            .padding(.horizontal, horizontalPadding)

            if viewModel.isLoading {
                ProgressView()
                    .padding()
            }
        }
    }
    
    
    private func paddedMovies() -> [Movie?] {
        let movies = viewModel.allMovies
        let remainder = movies.count % 3
        if remainder == 0 {
            return movies
        } else {
            let padding = 3 - remainder
            return movies + Array(repeating: nil, count: padding)
        }
    }
}


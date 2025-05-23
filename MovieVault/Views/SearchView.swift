//
//  SearchView.swift
//  MovieVault
//
//  Created by Faza Faresha Affandi on 23/05/25.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: MovieViewModel
    @State private var query: String = ""
    @State private var hasSearched = false
    @State private var submittedQuery: String = ""
    @Environment(\.presentationMode) var presentationMode

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
        VStack {
            if !hasSearched && viewModel.searchResults.isEmpty {
                Text("Search your film")
                    .foregroundColor(.primary)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 100)
                    .padding(.horizontal)
            } else if hasSearched && viewModel.searchResults.isEmpty && !viewModel.isLoading {
                VStack {
                    Text("\"\(submittedQuery)\" not found")
                        .foregroundColor(.primary)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.horizontal)
                }
                .padding(.top, 100)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: spacing) {
                        let movies = paddedMovies()

                        ForEach(movies.indices, id: \.self) { index in
                            if let movie = movies[index] {
                                NavigationLink(destination: DetailMovieView(movie: movie)) {
                                    MovieCardView(movie: movie, width: cardWidth)
                                        .frame(height: 250)
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
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    viewModel.clearSearchResults()
                    query = ""
                    submittedQuery = ""
                    hasSearched = false
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
            }
        }
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always))
        .onSubmit(of: .search) {
            hasSearched = true
            submittedQuery = query
            viewModel.searchMovies(by: query)
        }
    }

    private func paddedMovies() -> [Movie?] {
        let movies = viewModel.searchResults
        let remainder = movies.count % 3
        if remainder == 0 {
            return movies
        } else {
            let padding = 3 - remainder
            return movies + Array(repeating: nil, count: padding)
        }
    }
}

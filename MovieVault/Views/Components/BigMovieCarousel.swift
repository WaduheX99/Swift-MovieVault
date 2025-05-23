//
//  BigMovieCarousel.swift
//  MovieVault
//
//  Created by Faza Faresha Affandi on 22/05/25.
//

import SwiftUI

struct BigMovieCarousel: View {
    let movies: [Movie]
    @State private var currentIndex = 0
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geo in
                if let backdropPath = movies[safe: currentIndex]?.backdropPath,
                   let url = URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)") {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height + 200)
                            .clipped()
                            .blur(radius: 25)
                            .overlay(Color.black.opacity(0.5))
                            .offset(y: -200)
                    } placeholder: {
                        Color.black.opacity(0.5)
                            .frame(width: geo.size.width, height: geo.size.height)
                    }
                } else {
                    Color.black.opacity(0.5)
                        .frame(width: geo.size.width, height: geo.size.height)
                }
            }
            .allowsHitTesting(false)

            VStack {
                TabView(selection: $currentIndex) {
                    ForEach(Array(movies.enumerated()), id: \.offset) { index, movie in
                        NavigationLink(destination: DetailMovieView(movie: movie)) {
                            VStack(spacing: 12) {
                                if let poster = movie.posterPath,
                                   let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(poster)") {
                                    AsyncImage(url: posterURL) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxHeight: 300)
                                            .cornerRadius(12)
                                            .shadow(radius: 8)
                                    } placeholder: {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(height: 300)
                                    }
                                }

                                VStack(spacing: 6) {
                                    Text(movie.title)
                                        .font(.title2)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .foregroundColor(.white)
                                        .padding(.horizontal)

                                    HStack {
                                        ForEach(movie.genreNames.prefix(2), id: \.self) { genre in
                                            Text(genre)
                                                .font(.caption)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 5)
                                                .background(Color.white.opacity(0.2))
                                                .clipShape(Capsule())
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 8)
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 460)
                .onReceive(timer) { _ in
                    withAnimation {
                        currentIndex = (currentIndex + 1) % movies.count
                    }
                }

                HStack(spacing: 8) {
                    ForEach(0..<movies.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex ? Color.white : Color.gray.opacity(0.5))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 10)
            }
        }
        .frame(height: 460)
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

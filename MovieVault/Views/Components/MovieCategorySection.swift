//
//  MovieCategorySection.swift
//  MovieVault
//
//  Created by Faza Faresha Affandi on 22/05/25.
//

import SwiftUI

struct MovieCategorySection: View {
    let title: String
    let movies: [Movie]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title2)
                .bold()
                .padding(.horizontal)

            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                let spacing: CGFloat = 16
                let padding: CGFloat = 32
                let availableWidth = screenWidth - padding - (spacing * 2)
                let cardWidth = availableWidth / 3

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: spacing) {
                        ForEach(movies) { movie in
                            MovieCardView(movie: movie, width: cardWidth)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .frame(height: 250) // tetap cukup untuk poster + title
        }
    }
}



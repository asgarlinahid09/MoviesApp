//
//  MovieCard.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 23.09.26.
//

import SwiftUI

struct MovieCard: View {
    let posterURL: URL?
    let rating: Double
    var width: CGFloat = 160
    var height: CGFloat = 230

    var body: some View {
        MoviePosterView(posterURL: posterURL)
            .frame(width: width, height: height)
            .overlay(alignment: .topLeading) {
                RatingBadge(rating: rating)
                    .padding(6)
            }
    }
}

#Preview {
    MovieCard(
        posterURL: URL(string: "https://image.tmdb.org/t/p/w500/ngl2FKBlU4fhbdsrtdom9LVLBXw.jpg"),
        rating: 9.8
    )
    .padding()
}

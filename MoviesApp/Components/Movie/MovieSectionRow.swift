//
//  MovieSectionRow.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 23.09.26.
//

import SwiftUI

struct MovieSectionRow: View {
    let title: String
    let movies: [MovieDTO]
    let posterURL: (MovieDTO) -> URL?
    let onSeeAll: () -> Void
    let onSelect: (MovieDTO) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Button("See all", action: onSeeAll)
                    .font(.subheadline)
                    .foregroundStyle(.red)
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(movies) { movie in
                        Button {
                            onSelect(movie)
                        } label: {
                            MovieCard(posterURL: posterURL(movie), rating: movie.voteAverage)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    MovieSectionRow(
        title: "Top 10 Movies This Week",
        movies: MovieDTO.previewList,
        posterURL: { _ in URL(string: "https://image.tmdb.org/t/p/w500/ngl2FKBlU4fhbdsrtdom9LVLBXw.jpg") },
        onSeeAll: {},
        onSelect: { _ in }
    )
}

extension MovieDTO {
    static var previewList: [MovieDTO] {
        (1...5).map { index in
            MovieDTO(
                id: index,
                title: "Film \(index)",
                overview: "Nümunə təsvir",
                posterPath: "/ngl2FKBlU4fhbdsrtdom9LVLBXw.jpg",
                backdropPath: nil,
                releaseDate: "2024-01-01",
                voteAverage: Double.random(in: 6...9.5),
                genreIDs: [28, 12]
            )
        }
    }
}

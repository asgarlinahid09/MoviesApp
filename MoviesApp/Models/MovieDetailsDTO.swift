//
//  MovieDetailsDTO.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 23.09.26.
//

import Foundation

struct MovieDetailsDTO: Decodable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let runtime: Int?
    let voteAverage: Double
    let genres: [GenreDTO]
    let tagline: String?

    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres, tagline
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

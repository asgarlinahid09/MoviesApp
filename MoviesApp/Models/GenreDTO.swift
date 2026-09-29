//
//  GenreDTO.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 22.09.26.
//

import Foundation

struct GenresResponseDTO: Decodable {
    let genres: [GenreDTO]
}

struct GenreDTO: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
}

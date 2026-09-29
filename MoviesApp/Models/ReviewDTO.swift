//
//  ReviewDTO.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 23.09.26.
//

import Foundation

struct ReviewsResponseDTO: Decodable {
    let page: Int
    let results: [ReviewDTO]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct ReviewDTO: Decodable, Identifiable {
    let id: String
    let author: String
    let content: String
    let authorDetails: ReviewAuthorDetailsDTO

    enum CodingKeys: String, CodingKey {
        case id, author, content
        case authorDetails = "author_details"
    }
}

struct ReviewAuthorDetailsDTO: Decodable {
    let rating: Double?
    let avatarPath: String?

    enum CodingKeys: String, CodingKey {
        case rating
        case avatarPath = "avatar_path"
    }
}

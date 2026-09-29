//
//  CreditsDTO.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 23.09.26.
//

import Foundation

struct CreditsDTO: Decodable {
    let cast: [CastMemberDTO]
}

struct CastMemberDTO: Decodable, Identifiable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id, name, character
        case profilePath = "profile_path"
    }
}

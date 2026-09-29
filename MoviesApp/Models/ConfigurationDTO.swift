//
//  ConfigurationDTO.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 22.09.26.
//

import Foundation

struct ConfigurationDTO: Decodable {
    let images: ImagesConfigurationDTO
}

struct ImagesConfigurationDTO: Decodable {
    let secureBaseURL: String
    let posterSizes: [String]
    let backdropSizes: [String]

    enum CodingKeys: String, CodingKey {
        case secureBaseURL = "secure_base_url"
        case posterSizes = "poster_sizes"
        case backdropSizes = "backdrop_sizes"
    }
}

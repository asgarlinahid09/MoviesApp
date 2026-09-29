//
//  VideoDTO.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 23.09.26.
//

import Foundation

struct VideosResponseDTO: Decodable {
    let results: [VideoDTO]
}

struct VideoDTO: Decodable, Identifiable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
    let official: Bool
}

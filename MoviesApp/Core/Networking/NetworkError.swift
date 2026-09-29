//
//  NetworkError.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 21.09.26.
//

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case encodingError
    case serverError(statusCode: Int)
    case unknown(Error)
}

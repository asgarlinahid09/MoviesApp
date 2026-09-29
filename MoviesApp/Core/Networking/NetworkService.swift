//
//  NetworkService.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 21.09.26.
//

import Foundation

protocol NetworkService: AnyObject {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

final class DefaultNetworkService: NetworkService {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        switch endpoint.makeRequest() {
        case .success(let urlRequest):
            let (data, response) = try await session.data(for: urlRequest)
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError
            }
        case .failure(let error):
            throw error
        }
    }
}

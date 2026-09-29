//
//  Endpoint.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 21.09.26.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var httpBody: Encodable? { get }
}

extension Endpoint {
    func makeRequest() -> Result<URLRequest, NetworkError> {
        guard var components = URLComponents(string: baseURL) else {
            return .failure(.invalidURL)
        }
        components.path = path
        components.queryItems = queryItems
        guard let url = components.url else { return .failure(.invalidURL) }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let httpBody {
            do {
                request.httpBody = try JSONEncoder().encode(httpBody)
            } catch {
                return .failure(.encodingError)
            }
        }
        return .success(request)
    }
}

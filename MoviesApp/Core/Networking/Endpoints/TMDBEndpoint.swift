//
//  TMDBEndpoint.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 21.09.26.
//

import Foundation

enum TMDBEndpoint {
    case configuration
    case popularMovies(page: Int)
    case topRatedMovies(page: Int)
    case nowPlayingMovies(page: Int)
    case upcomingMovies(page: Int)
    case searchMovies(query: String, page: Int)
    case movieGenres
    case discoverMovies(genreId: Int?, sortBy: DiscoverSortOption?, year: Int?, page: Int)
    case movieDetails(id: Int)
    case movieCredits(id: Int)
    case movieVideos(id: Int)
    case similarMovies(id: Int, page: Int)
    case movieReviews(id: Int, page: Int)
}

enum DiscoverSortOption: String {
    case popularityDescending = "popularity.desc"
    case popularityAscending = "popularity.asc"
    case releaseDateDescending = "primary_release_date.desc"
    case releaseDateAscending = "primary_release_date.asc"
    case ratingDescending = "vote_average.desc"
}

extension TMDBEndpoint: Endpoint {
    var baseURL: String { "https://api.themoviedb.org" }

    var path: String {
        switch self {
        case .configuration:
            return "/3/configuration"
        case .popularMovies:
            return "/3/movie/popular"
        case .topRatedMovies:
            return "/3/movie/top_rated"
        case .nowPlayingMovies:
            return "/3/movie/now_playing"
        case .upcomingMovies:
            return "/3/movie/upcoming"
        case .searchMovies:
            return "/3/search/movie"
        case .movieGenres:
            return "/3/genre/movie/list"
        case .discoverMovies:
            return "/3/discover/movie"
        case .movieDetails(let id):
            return "/3/movie/\(id)"
        case .movieCredits(let id):
            return "/3/movie/\(id)/credits"
        case .movieVideos(let id):
            return "/3/movie/\(id)/videos"
        case .similarMovies(let id, _):
            return "/3/movie/\(id)/similar"
        case .movieReviews(let id, _):
            return "/3/movie/\(id)/reviews"
        }
    }

    var method: HTTPMethod { .get }

    var headers: [String: String]? {
        ["Authorization": "Bearer \(TMDBConfig.apiKey)"]
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .configuration, .movieDetails, .movieCredits, .movieVideos:
            return nil

        case .popularMovies(let page),
             .topRatedMovies(let page),
             .nowPlayingMovies(let page),
             .upcomingMovies(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]

        case .searchMovies(let query, let page):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: "\(page)")
            ]

        case .movieGenres:
            return nil

        case .discoverMovies(let genreID, let sortBy, let year, let page):
            var items: [URLQueryItem] = [URLQueryItem(name: "page", value: "\(page)")]
            if let genreID {
                items.append(URLQueryItem(name: "with_genres", value: "\(genreID)"))
            }
            if let sortBy {
                items.append(URLQueryItem(name: "sort_by", value: sortBy.rawValue))
            }
            if let year {
                items.append(URLQueryItem(name: "primary_release_year", value: "\(year)"))
            }
            return items

        case .similarMovies(_, let page), .movieReviews(_, let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        }
    }

    var httpBody: Encodable? { nil }
}

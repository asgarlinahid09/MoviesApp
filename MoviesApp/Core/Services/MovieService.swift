//
//  MovieService.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 23.09.26.
//

import Foundation

protocol MovieServiceProtocol: AnyObject {
    func fetchPopularMovies(page: Int) async throws -> MoviesResponseDTO
    func fetchTopRatedMovies(page: Int) async throws -> MoviesResponseDTO
    func fetchNowPlayingMovies(page: Int) async throws -> MoviesResponseDTO
    func fetchUpcomingMovies(page: Int) async throws -> MoviesResponseDTO
    func searchMovies(query: String, page: Int) async throws -> MoviesResponseDTO
    func fetchGenres() async throws -> [GenreDTO]
    func discoverMovies(genreID: Int?, sortBy: DiscoverSortOption?, year: Int?, page: Int) async throws -> MoviesResponseDTO

    func fetchMovieDetails(id: Int) async throws -> MovieDetailsDTO
    func fetchCredits(movieID: Int) async throws -> CreditsDTO
    func fetchVideos(movieID: Int) async throws -> [VideoDTO]
    func fetchSimilarMovies(movieID: Int, page: Int) async throws -> MoviesResponseDTO
    func fetchReviews(movieID: Int, page: Int) async throws -> ReviewsResponseDTO

    func posterURL(path: String?, size: String) async -> URL?
}

final class MovieService: MovieServiceProtocol {
    private let networkService: NetworkService
    private var cachedImageConfiguration: ImagesConfigurationDTO?

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchPopularMovies(page: Int) async throws -> MoviesResponseDTO {
        try await networkService.request(TMDBEndpoint.popularMovies(page: page))
    }

    func fetchTopRatedMovies(page: Int) async throws -> MoviesResponseDTO {
        try await networkService.request(TMDBEndpoint.topRatedMovies(page: page))
    }

    func fetchNowPlayingMovies(page: Int) async throws -> MoviesResponseDTO {
        try await networkService.request(TMDBEndpoint.nowPlayingMovies(page: page))
    }

    func fetchUpcomingMovies(page: Int) async throws -> MoviesResponseDTO {
        try await networkService.request(TMDBEndpoint.upcomingMovies(page: page))
    }

    func searchMovies(query: String, page: Int) async throws -> MoviesResponseDTO {
        try await networkService.request(TMDBEndpoint.searchMovies(query: query, page: page))
    }

    func fetchGenres() async throws -> [GenreDTO] {
        let response: GenresResponseDTO = try await networkService.request(TMDBEndpoint.movieGenres)
        return response.genres
    }

    func discoverMovies(genreID: Int?, sortBy: DiscoverSortOption?, year: Int?, page: Int) async throws -> MoviesResponseDTO {
        try await networkService.request(TMDBEndpoint.discoverMovies(genreId: genreID, sortBy: sortBy, year: year, page: page))
    }

    func fetchMovieDetails(id: Int) async throws -> MovieDetailsDTO {
        try await networkService.request(TMDBEndpoint.movieDetails(id: id))
    }

    func fetchCredits(movieID: Int) async throws -> CreditsDTO {
        try await networkService.request(TMDBEndpoint.movieCredits(id: movieID))
    }

    func fetchVideos(movieID: Int) async throws -> [VideoDTO] {
        let response: VideosResponseDTO = try await networkService.request(TMDBEndpoint.movieVideos(id: movieID))
        return response.results
    }

    func fetchSimilarMovies(movieID: Int, page: Int) async throws -> MoviesResponseDTO {
        try await networkService.request(TMDBEndpoint.similarMovies(id: movieID, page: page))
    }

    func fetchReviews(movieID: Int, page: Int) async throws -> ReviewsResponseDTO {
        try await networkService.request(TMDBEndpoint.movieReviews(id: movieID, page: page))
    }

    func posterURL(path: String?, size: String = "w500") async -> URL? {
        guard let path else { return nil }
        guard let configuration = await imageConfiguration() else { return nil }
        return URL(string: configuration.secureBaseURL + size + path)
    }

    private func imageConfiguration() async -> ImagesConfigurationDTO? {
        if let cachedImageConfiguration { return cachedImageConfiguration }
        guard let response: ConfigurationDTO = try? await networkService.request(TMDBEndpoint.configuration) else {
            return nil
        }
        cachedImageConfiguration = response.images
        return response.images
    }
}

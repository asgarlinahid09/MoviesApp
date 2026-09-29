//
//  MovieListViewModel.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 23.09.26.
//

import Foundation

enum MovieListKind: Hashable {
    case topMovies
    case newReleases

    var title: String {
        switch self {
        case .topMovies: return "Top 10 Movies This Week"
        case .newReleases: return "New Releases"
        }
    }
}

@Observable
final class MovieListViewModel {
    private let kind: MovieListKind
    private let movieService: MovieServiceProtocol

    var movies: [MovieDTO] = []
    var posterURLs: [Int: URL] = [:]
    var isLoading = false
    var errorMessage: String?
    var searchQuery: String = ""

    var title: String { kind.title }

    var displayedMovies: [MovieDTO] {
        let trimmed = searchQuery.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return movies }
        return movies.filter { $0.title.localizedCaseInsensitiveContains(trimmed) }
    }

    init(kind: MovieListKind, movieService: MovieServiceProtocol) {
        self.kind = kind
        self.movieService = movieService
    }

    func loadInitial() async {
        guard movies.isEmpty else { return }
        isLoading = true
        errorMessage = nil

        do {
            let response = try await fetchResponse()
            movies = response.results
            await loadPosterURLs(for: movies)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    private func fetchResponse() async throws -> MoviesResponseDTO {
        switch kind {
        case .topMovies:
            return try await movieService.fetchPopularMovies(page: 1)
        case .newReleases:
            return try await movieService.fetchNowPlayingMovies(page: 1)
        }
    }

    private func loadPosterURLs(for movies: [MovieDTO]) async {
        for movie in movies {
            if let url = await movieService.posterURL(path: movie.posterPath, size: "w500") {
                posterURLs[movie.id] = url
            }
        }
    }

    func posterURL(for movie: MovieDTO) -> URL? {
        posterURLs[movie.id]
    }
}

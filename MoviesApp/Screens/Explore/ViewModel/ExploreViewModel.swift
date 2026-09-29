//
//  ExploreViewModel.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 24.09.26.
//

import Foundation

enum ExploreMode {
    case browsing
    case searching
}

@Observable
final class ExploreViewModel {
    private let movieService: MovieServiceProtocol

    var searchText: String = ""
    var movies: [MovieDTO] = []
    var posterURLs: [Int: URL] = [:]
    var genres: [GenreDTO] = []
    var selectedGenre: GenreDTO?
    var selectedSort: DiscoverSortOption?
    var selectedYear: Int?
    var isFilterPresented = false
    var isLoading = false
    var isLoadingMore = false
    var hasSearched = false
    var errorMessage: String?

    private var currentPage = 1
    private var totalPages = 1

    @ObservationIgnored
    private var searchTask: Task<Void, Never>?

    var mode: ExploreMode {
        searchText.trimmingCharacters(in: .whitespaces).isEmpty ? .browsing : .searching
    }

    var isFilterActive: Bool {
        selectedGenre != nil || selectedSort != nil || selectedYear != nil
    }

    var availableYears: [Int] {
        let currentYear = Calendar.current.component(.year, from: .now)
        return Array((currentYear - 6)...currentYear).reversed()
    }

    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
    }

    func loadInitialIfNeeded() async {
        if genres.isEmpty {
            genres = (try? await movieService.fetchGenres()) ?? []
        }
        guard movies.isEmpty else { return }
        await reload()
    }

    func onSearchTextChanged() {
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(400))
            guard !Task.isCancelled else { return }
            await reload()
        }
    }

    func applyFilter() async {
        isFilterPresented = false
        await reload()
    }

    func resetFilter() async {
        selectedGenre = nil
        selectedSort = nil
        selectedYear = nil
        await reload()
    }

    private func reload() async {
        isLoading = true
        errorMessage = nil
        hasSearched = (mode == .searching)

        do {
            let response = try await fetchPage(1)
            movies = response.results
            currentPage = response.page
            totalPages = response.totalPages
            await loadPosterURLs(for: movies)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func loadMoreIfNeeded(currentItem movie: MovieDTO) async {
        guard let index = movies.firstIndex(where: { $0.id == movie.id }) else { return }
        let thresholdIndex = movies.index(movies.endIndex, offsetBy: -4, limitedBy: movies.startIndex) ?? movies.startIndex
        guard index >= thresholdIndex, currentPage < totalPages, !isLoadingMore else { return }

        isLoadingMore = true
        do {
            let response = try await fetchPage(currentPage + 1)
            movies.append(contentsOf: response.results)
            currentPage = response.page
            totalPages = response.totalPages
            await loadPosterURLs(for: response.results)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoadingMore = false
    }

    private func fetchPage(_ page: Int) async throws -> MoviesResponseDTO {
        switch mode {
        case .browsing:
            return try await movieService.discoverMovies(
                genreID: selectedGenre?.id,
                sortBy: selectedSort,
                year: selectedYear,
                page: page
            )
        case .searching:
            return try await movieService.searchMovies(query: searchText, page: page)
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

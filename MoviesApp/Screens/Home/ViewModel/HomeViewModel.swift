//
//  HomeViewModel.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 23.09.26.
//

import Foundation

@Observable
final class HomeViewModel {
    private let movieService: MovieServiceProtocol
    private let myListService: MyListServiceProtocol

    var topMovies: [MovieDTO] = []
    var newReleases: [MovieDTO] = []
    var posterURLs: [Int: URL] = [:]
    var savedMovieIDs: Set<Int> = []
    var isLoading = false
    var errorMessage: String?

    private var genreNamesByID: [Int: String] = [:]

    init(movieService: MovieServiceProtocol, myListService: MyListServiceProtocol) {
        self.movieService = movieService
        self.myListService = myListService
    }

    func loadData() async {
        guard topMovies.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        do {
            async let popular = movieService.fetchPopularMovies(page: 1)
            async let newReleasesResponse = movieService.fetchNowPlayingMovies(page: 1)
            async let genres = movieService.fetchGenres()

            let (popularResult, newReleasesResult, genresResult) = try await (popular, newReleasesResponse, genres)

            topMovies = popularResult.results
            newReleases = newReleasesResult.results
            genreNamesByID = Dictionary(uniqueKeysWithValues: genresResult.map { ($0.id, $0.name) })
            savedMovieIDs = Set(myListService.fetchAll().map(\.id))

            await loadPosterURLs(for: topMovies + newReleases)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
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

    func genreText(for movie: MovieDTO) -> String {
        guard let genreIDs = movie.genreIDs, !genreIDs.isEmpty else { return "" }
        return genreIDs.compactMap { genreNamesByID[$0] }.joined(separator: ", ")
    }

    func isSaved(_ movie: MovieDTO) -> Bool {
        savedMovieIDs.contains(movie.id)
    }

    func toggleMyList(for movie: MovieDTO) {
        if savedMovieIDs.contains(movie.id) {
            myListService.remove(movieID: movie.id)
            savedMovieIDs.remove(movie.id)
        } else {
            myListService.add(movieID: movie.id, title: movie.title, posterPath: movie.posterPath, voteAverage: movie.voteAverage)
            savedMovieIDs.insert(movie.id)
        }
    }
    
    func refreshSavedMovieIDs() {
        savedMovieIDs = Set(myListService.fetchAll().map(\.id))
    }
}

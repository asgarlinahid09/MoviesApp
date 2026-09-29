//
//  MyListViewModel.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 24.09.26.
//

import Foundation

@Observable
final class MyListViewModel {
    private let movieService: MovieServiceProtocol
    private let myListService: MyListServiceProtocol

    var savedMovies: [SavedMovie] = []
    var posterURLs: [Int: URL] = [:]

    init(movieService: MovieServiceProtocol, myListService: MyListServiceProtocol) {
        self.movieService = movieService
        self.myListService = myListService
    }

    func loadData() async {
        savedMovies = myListService.fetchAll()
        await loadPosterURLs()
    }

    private func loadPosterURLs() async {
        for movie in savedMovies {
            if let url = await movieService.posterURL(path: movie.posterPath, size: "w500") {
                posterURLs[movie.id] = url
            }
        }
    }

    func posterURL(for movie: SavedMovie) -> URL? {
        posterURLs[movie.id]
    }

    func remove(_ movie: SavedMovie) {
        myListService.remove(movieID: movie.id)
        savedMovies.removeAll { $0.id == movie.id }
    }
}

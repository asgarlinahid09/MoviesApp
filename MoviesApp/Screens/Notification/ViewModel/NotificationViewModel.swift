//
//  NotificationViewModel.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 23.09.26.
//

import Foundation

struct NotificationItem: Identifiable {
    let id: Int
    let title: String
    let posterURL: URL?
    let dateText: String
}

@Observable
final class NotificationViewModel {
    private let movieService: MovieServiceProtocol

    var items: [NotificationItem] = []
    var isLoading = false
    var errorMessage: String?

    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
    }

    func loadData() async {
        guard items.isEmpty else { return }
        isLoading = true
        errorMessage = nil

        do {
            let response = try await movieService.fetchNowPlayingMovies(page: 1)
            var newItems: [NotificationItem] = []

            for movie in response.results.prefix(10) {
                let url = await movieService.posterURL(path: movie.posterPath, size: "w200")
                newItems.append(
                    NotificationItem(id: movie.id, title: movie.title, posterURL: url, dateText: movie.releaseDate ?? "")
                )
            }

            items = newItems
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

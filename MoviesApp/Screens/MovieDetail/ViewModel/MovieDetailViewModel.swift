//
//  MovieDetailViewModel.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 24.09.26.
//

import Foundation

@Observable
final class MovieDetailViewModel {
    private let movieID: Int
    private let movieService: MovieServiceProtocol
    private let myListService: MyListServiceProtocol
    private let downloadService: DownloadServiceProtocol

    var details: MovieDetailsDTO?
    var cast: [CastMemberDTO] = []
    var videos: [VideoDTO] = []
    var similarMovies: [MovieDTO] = []
    var reviews: [ReviewDTO] = []

    var posterURL: URL?
    var castProfileURLs: [Int: URL] = [:]
    var similarPosterURLs: [Int: URL] = [:]

    var isSaved = false
    var isDownloaded = false
    var isDownloading = false

    var isLoading = false
    var errorMessage: String?

    init(
        movieID: Int,
        movieService: MovieServiceProtocol,
        myListService: MyListServiceProtocol,
        downloadService: DownloadServiceProtocol
    ) {
        self.movieID = movieID
        self.movieService = movieService
        self.myListService = myListService
        self.downloadService = downloadService
    }

    func loadData() async {
        guard details == nil else { return }
        isLoading = true
        errorMessage = nil

        do {
            async let detailsResponse = movieService.fetchMovieDetails(id: movieID)
            async let creditsResponse = movieService.fetchCredits(movieID: movieID)
            async let videosResponse = movieService.fetchVideos(movieID: movieID)
            async let similarResponse = movieService.fetchSimilarMovies(movieID: movieID, page: 1)
            async let reviewsResponse = movieService.fetchReviews(movieID: movieID, page: 1)

            let (detailsResult, creditsResult, videosResult, similarResult, reviewsResult) =
                try await (detailsResponse, creditsResponse, videosResponse, similarResponse, reviewsResponse)

            details = detailsResult
            cast = creditsResult.cast
            videos = videosResult.filter { $0.site == "YouTube" && $0.type == "Trailer" }
            similarMovies = similarResult.results
            reviews = reviewsResult.results

            posterURL = await movieService.posterURL(path: detailsResult.posterPath, size: "w500")
            refreshSavedStatus()

            await loadCastProfileURLs()
            await loadSimilarPosterURLs()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    private func loadCastProfileURLs() async {
        for member in cast.prefix(10) {
            if let url = await movieService.posterURL(path: member.profilePath, size: "w185") {
                castProfileURLs[member.id] = url
            }
        }
    }

    private func loadSimilarPosterURLs() async {
        for movie in similarMovies.prefix(10) {
            if let url = await movieService.posterURL(path: movie.posterPath, size: "w500") {
                similarPosterURLs[movie.id] = url
            }
        }
    }

    func castProfileURL(for member: CastMemberDTO) -> URL? {
        castProfileURLs[member.id]
    }

    func similarPosterURL(for movie: MovieDTO) -> URL? {
        similarPosterURLs[movie.id]
    }

    func trailerURL(for video: VideoDTO) -> URL? {
        URL(string: "https://www.youtube.com/watch?v=\(video.key)")
    }

    var primaryTrailerURL: URL? {
        guard let first = videos.first else { return nil }
        return trailerURL(for: first)
    }

    var shareURL: URL? {
        guard let details else { return nil }
        return URL(string: "https://www.themoviedb.org/movie/\(details.id)")
    }

    func toggleMyList() {
        guard let details else { return }
        if isSaved {
            myListService.remove(movieID: movieID)
            isSaved = false
        } else {
            myListService.add(
                movieID: movieID,
                title: details.title,
                posterPath: details.posterPath,
                voteAverage: details.voteAverage
            )
            isSaved = true
        }
    }


    func toggleDownload() async {
        guard let details else { return }

        if isDownloaded {
            downloadService.remove(movieID: movieID)
            isDownloaded = false
        } else {
            isDownloading = true
            try? await downloadService.download(
                movieID: movieID,
                title: details.title,
                runtime: details.runtime,
                posterURL: posterURL
            )
            isDownloaded = downloadService.isDownloaded(movieID: movieID)
            isDownloading = false
        }
    }

    func refreshSavedStatus() {
        isSaved = myListService.isSaved(movieID: movieID)
        isDownloaded = downloadService.isDownloaded(movieID: movieID)
    }
}

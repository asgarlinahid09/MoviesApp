//
//  DownloadViewModel.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 25.09.26.
//

import Foundation
import UIKit

@Observable
final class DownloadViewModel {
    private let downloadService: DownloadServiceProtocol

    var downloads: [DownloadedMovie] = []
    var images: [Int: UIImage] = [:]
    var searchQuery: String = ""

    var filteredDownloads: [DownloadedMovie] {
        let trimmed = searchQuery.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return downloads }
        return downloads.filter { $0.title.localizedCaseInsensitiveContains(trimmed) }
    }

    init(downloadService: DownloadServiceProtocol) {
        self.downloadService = downloadService
    }

    func loadData() {
        downloads = downloadService.fetchAll()
        for movie in downloads {
            images[movie.id] = downloadService.localImage(for: movie)
        }
    }

    func remove(_ movie: DownloadedMovie) {
        downloadService.remove(movieID: movie.id)
        downloads.removeAll { $0.id == movie.id }
        images[movie.id] = nil
    }

    func fileSizeText(for movie: DownloadedMovie) -> String {
        ByteCountFormatter.string(fromByteCount: movie.fileSizeBytes, countStyle: .file)
    }

    func durationText(for movie: DownloadedMovie) -> String {
        guard let runtime = movie.runtime else { return "" }
        let hours = runtime / 60
        let minutes = runtime % 60
        return hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
    }
}

//
//  DownloadService.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 25.09.26.
//

import Foundation
import SwiftData
import UIKit

enum DownloadError: Error {
    case noPosterURL
    case writeFailed
}

protocol DownloadServiceProtocol: AnyObject {
    func isDownloaded(movieID: Int) -> Bool
    func download(movieID: Int, title: String, runtime: Int?, posterURL: URL?) async throws
    func remove(movieID: Int)
    func fetchAll() -> [DownloadedMovie]
    func localImage(for movie: DownloadedMovie) -> UIImage?
}

final class DownloadService: DownloadServiceProtocol {
    private let modelContext: ModelContext
    private let session: URLSession

    init(modelContext: ModelContext, session: URLSession = .shared) {
        self.modelContext = modelContext
        self.session = session
    }

    private var downloadsDirectory: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folder = documents.appendingPathComponent("Downloads", isDirectory: true)
        if !FileManager.default.fileExists(atPath: folder.path) {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        return folder
    }

    func isDownloaded(movieID: Int) -> Bool {
        let descriptor = FetchDescriptor<DownloadedMovie>(predicate: #Predicate { $0.id == movieID })
        return (try? modelContext.fetchCount(descriptor)) ?? 0 > 0
    }

    func download(movieID: Int, title: String, runtime: Int?, posterURL: URL?) async throws {
        guard !isDownloaded(movieID: movieID) else { return }
        guard let posterURL else { throw DownloadError.noPosterURL }

        let (data, _) = try await session.data(from: posterURL)

        let fileName = "\(movieID).jpg"
        let fileURL = downloadsDirectory.appendingPathComponent(fileName)

        do {
            try data.write(to: fileURL)
        } catch {
            throw DownloadError.writeFailed
        }

        let downloaded = DownloadedMovie(
            id: movieID,
            title: title,
            runtime: runtime,
            fileName: fileName,
            fileSizeBytes: Int64(data.count)
        )
        modelContext.insert(downloaded)
        try? modelContext.save()
    }

    func remove(movieID: Int) {
        let descriptor = FetchDescriptor<DownloadedMovie>(predicate: #Predicate { $0.id == movieID })
        guard let existing = try? modelContext.fetch(descriptor).first else { return }

        let fileURL = downloadsDirectory.appendingPathComponent(existing.fileName)
        try? FileManager.default.removeItem(at: fileURL)

        modelContext.delete(existing)
        try? modelContext.save()
    }

    func fetchAll() -> [DownloadedMovie] {
        let descriptor = FetchDescriptor<DownloadedMovie>(sortBy: [SortDescriptor(\.downloadedAt, order: .reverse)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func localImage(for movie: DownloadedMovie) -> UIImage? {
        let fileURL = downloadsDirectory.appendingPathComponent(movie.fileName)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }
}

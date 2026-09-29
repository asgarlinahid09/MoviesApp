//
//  DownloadedMovie.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 25.09.26.
//

import Foundation
import SwiftData

@Model
final class DownloadedMovie {
    @Attribute(.unique) var id: Int
    var title: String
    var runtime: Int?
    var fileName: String
    var fileSizeBytes: Int64
    var downloadedAt: Date

    init(id: Int, title: String, runtime: Int?, fileName: String, fileSizeBytes: Int64, downloadedAt: Date = .now) {
        self.id = id
        self.title = title
        self.runtime = runtime
        self.fileName = fileName
        self.fileSizeBytes = fileSizeBytes
        self.downloadedAt = downloadedAt
    }
}

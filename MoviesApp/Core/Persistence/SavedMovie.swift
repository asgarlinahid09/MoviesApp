//
//  SavedMovie.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 24.09.26.
//


import Foundation
import SwiftData

@Model
final class SavedMovie {
    @Attribute(.unique) var id: Int
    var title: String
    var posterPath: String?
    var voteAverage: Double
    var savedAt: Date

    init(id: Int, title: String, posterPath: String?, voteAverage: Double, savedAt: Date = .now) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.voteAverage = voteAverage
        self.savedAt = savedAt
    }
}

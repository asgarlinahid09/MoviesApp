//
//  MyListService.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 24.09.26.
//

import Foundation
import SwiftData

protocol MyListServiceProtocol: AnyObject {
    func isSaved(movieID: Int) -> Bool
    func add(movieID: Int, title: String, posterPath: String?, voteAverage: Double)
    func remove(movieID: Int)
    func fetchAll() -> [SavedMovie]
}

final class MyListService: MyListServiceProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func isSaved(movieID: Int) -> Bool {
        let descriptor = FetchDescriptor<SavedMovie>(
            predicate: #Predicate { $0.id == movieID }
        )
        return (try? modelContext.fetchCount(descriptor)) ?? 0 > 0
    }

    func add(movieID: Int, title: String, posterPath: String?, voteAverage: Double) {
        guard !isSaved(movieID: movieID) else { return }
        let saved = SavedMovie(id: movieID, title: title, posterPath: posterPath, voteAverage: voteAverage)
        modelContext.insert(saved)
        try? modelContext.save()
    }

    func remove(movieID: Int) {
        let descriptor = FetchDescriptor<SavedMovie>(
            predicate: #Predicate { $0.id == movieID }
        )
        if let existing = try? modelContext.fetch(descriptor).first {
            modelContext.delete(existing)
            try? modelContext.save()
        }
    }

    func fetchAll() -> [SavedMovie] {
        let descriptor = FetchDescriptor<SavedMovie>(
            sortBy: [SortDescriptor(\.savedAt, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
}

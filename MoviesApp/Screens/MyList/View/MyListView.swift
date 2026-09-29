//
//  MyListView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 24.09.26.
//

import SwiftUI

enum MyListCategory: String, CaseIterable, Identifiable {
    case all = "All Categories"
    case movie = "Movie"
    case tvSeries = "TV Series"

    var id: String { rawValue }
}

struct MyListView: View {
    @Environment(MainCoordinator.self) private var coordinator
    let viewModel: MyListViewModel
    @State private var selectedCategory: MyListCategory = .all
    @State private var movieToDelete: SavedMovie?

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        @Bindable var coordinator = coordinator

        NavigationStack(path: $coordinator.myListPath) {
            VStack(spacing: 0) {
                categoryChips
                listContent
            }
            .navigationTitle("My List")
            .mainScreenDestinations(coordinator: coordinator)
        }
        .onAppear {
            Task { await viewModel.loadData() }
        }
        .confirmationDialog(
            "Remove from My List?",
            isPresented: Binding(
                get: { movieToDelete != nil },
                set: { if !$0 { movieToDelete = nil } }
            ),
            titleVisibility: .visible
        ) {
            removeConfirmationButtons
        }
    }


    @ViewBuilder
    private var listContent: some View {
        if selectedCategory == .tvSeries {
            tvSeriesEmptyState
        } else if viewModel.savedMovies.isEmpty {
            emptyState
        } else {
            moviesGrid
        }
    }

    private var moviesGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.savedMovies, id: \.id) { movie in
                    movieCard(movie)
                }
            }
            .padding(16)
        }
    }


    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(MyListCategory.allCases) { category in
                    categoryChip(category)
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 12)
    }

    private func categoryChip(_ category: MyListCategory) -> some View {
        Button {
            selectedCategory = category
        } label: {
            Text(category.rawValue)
                .font(.caption.bold())
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(selectedCategory == category ? Color.red : Color.white)
                .foregroundStyle(selectedCategory == category ? .white : .red)
                .overlay(
                    Capsule().stroke(Color.red.opacity(selectedCategory == category ? 0 : 0.4), lineWidth: 1)
                )
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }


    private func movieCard(_ movie: SavedMovie) -> some View {
        MoviePosterView(posterURL: viewModel.posterURL(for: movie))
            .frame(height: 220)
            .overlay(alignment: .topLeading) {
                RatingBadge(rating: movie.voteAverage)
                    .padding(6)
            }
            .onTapGesture {
                coordinator.push(.movieDetail(id: movie.id))
            }
            .onLongPressGesture {
                movieToDelete = movie
            }
    }


    @ViewBuilder
    private var removeConfirmationButtons: some View {
        Button("Remove", role: .destructive) {
            if let movie = movieToDelete {
                viewModel.remove(movie)
            }
            movieToDelete = nil
        }
        Button("Cancel", role: .cancel) { movieToDelete = nil }
    }


    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "bookmark")
                .font(.system(size: 48))
                .foregroundStyle(.gray)
            Text("Your List is Empty")
                .font(.headline)
                .foregroundStyle(.red)
            Text("It seems that you haven't added any movies to the list.")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var tvSeriesEmptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "tv")
                .font(.system(size: 48))
                .foregroundStyle(.gray)
            Text("No TV Series")
                .font(.headline)
                .foregroundStyle(.red)
            Text("This app currently supports movies only.")
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

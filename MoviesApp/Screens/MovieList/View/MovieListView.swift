//
//  MovieListView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 23.09.26.
//

import SwiftUI

struct MovieListView: View {
    @Environment(MainCoordinator.self) private var coordinator
    let viewModel: MovieListViewModel
    @State private var isSearchFieldVisible = false

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        @Bindable var viewModel = viewModel

        ScrollView {
            if isSearchFieldVisible {
                searchField(viewModel: viewModel)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
            }

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.displayedMovies) { movie in
                    Button {
                        coordinator.push(.movieDetail(id: movie.id))
                    } label: {
                        MoviePosterView(posterURL: viewModel.posterURL(for: movie))
                            .frame(height: 220)
                            .overlay(alignment: .topLeading) {
                                RatingBadge(rating: movie.voteAverage)
                                    .padding(6)
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation {
                        isSearchFieldVisible.toggle()
                        if !isSearchFieldVisible {
                            viewModel.searchQuery = ""
                        }
                    }
                } label: {
                    Image(systemName: isSearchFieldVisible ? "xmark" : "magnifyingglass")
                }
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .task {
            await viewModel.loadInitial()
        }
    }

    private func searchField(viewModel: MovieListViewModel) -> some View {
        @Bindable var viewModel = viewModel

        return HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)
            TextField("Search in this list", text: $viewModel.searchQuery)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

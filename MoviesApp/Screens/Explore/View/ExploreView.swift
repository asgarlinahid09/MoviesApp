//
//  ExploreView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 24.09.26.
//

import SwiftUI

struct ExploreView: View {
    @Environment(MainCoordinator.self) private var coordinator
    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        @Bindable var viewModel = coordinator.exploreViewModel
        @Bindable var coordinator = coordinator

        NavigationStack(path: $coordinator.explorePath) {
            VStack(spacing: 0) {
                searchBar(viewModel: viewModel)
                content(viewModel: viewModel)
            }
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $viewModel.isFilterPresented) {
                SortFilterSheet(viewModel: viewModel)
            }
            .mainScreenDestinations(coordinator: coordinator)
        }
        .task {
            await viewModel.loadInitialIfNeeded()
        }
    }

    private func searchBar(viewModel: ExploreViewModel) -> some View {
        @Bindable var viewModel = viewModel
        return HStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                TextField("Search", text: $viewModel.searchText)
                    .onChange(of: viewModel.searchText) {
                        viewModel.onSearchTextChanged()
                    }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(viewModel.searchText.isEmpty ? Color.clear : Color.red, lineWidth: 1)
            )

            Button {
                viewModel.isFilterPresented = true
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .foregroundStyle(viewModel.isFilterActive ? .white : .primary)
                    .padding(12)
                    .background(viewModel.isFilterActive ? Color.red : Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }

    @ViewBuilder
    private func content(viewModel: ExploreViewModel) -> some View {
        if viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if viewModel.movies.isEmpty && viewModel.hasSearched {
            notFoundState
        } else {
            grid(viewModel: viewModel)
        }
    }

    private func grid(viewModel: ExploreViewModel) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.movies) { movie in
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
                    .task {
                        await viewModel.loadMoreIfNeeded(currentItem: movie)
                    }
                }
            }
            .padding(16)

            if viewModel.isLoadingMore {
                ProgressView()
                    .padding(.vertical, 16)
            }
        }
    }

    private var notFoundState: some View {
        VStack(spacing: 12) {
            Image(systemName: "questionmark.folder")
                .font(.system(size: 48))
                .foregroundStyle(.gray)
            Text("Not Found")
                .font(.headline)
                .foregroundStyle(.red)
            Text("Sorry, the keyword you entered could not be found. Try to check again or search with other keywords.")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

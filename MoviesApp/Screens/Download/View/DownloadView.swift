//
//  DownloadView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 25.09.26.
//

import SwiftUI

struct DownloadView: View {
    @Bindable var viewModel: DownloadViewModel
    @State private var pendingDeleteMovie: DownloadedMovie?
    @State private var isSearchFieldVisible = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                topBar
                searchFieldIfVisible
                content
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            viewModel.loadData()
        }
        .alert(
            "Delete",
            isPresented: Binding(
                get: { pendingDeleteMovie != nil },
                set: { if !$0 { pendingDeleteMovie = nil } }
            )
        ) {
            Button("Cancel", role: .cancel) { pendingDeleteMovie = nil }
            Button("Yes, Delete", role: .destructive) {
                if let movie = pendingDeleteMovie {
                    viewModel.remove(movie)
                }
                pendingDeleteMovie = nil
            }
        } message: {
            Text("Are you sure you want to delete this movie download?")
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.downloads.isEmpty {
            emptyState
        } else {
            List(viewModel.filteredDownloads, id: \.id) { movie in
                row(movie)
            }
            .listStyle(.plain)
        }
    }

    private var topBar: some View {
        HStack {
            Text("M")
                .font(.system(size: 22, weight: .heavy))
                .foregroundStyle(.red)

            Text("Download")
                .font(.headline)

            Spacer()

            Button {
                withAnimation {
                    isSearchFieldVisible.toggle()
                    if !isSearchFieldVisible { viewModel.searchQuery = "" }
                }
            } label: {
                Image(systemName: isSearchFieldVisible ? "xmark" : "magnifyingglass")
                    .foregroundStyle(.primary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }

    @ViewBuilder
    private var searchFieldIfVisible: some View {
        if isSearchFieldVisible {
            searchField
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
        }
    }

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass").foregroundStyle(.gray)
            TextField("Search downloads", text: $viewModel.searchQuery)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func row(_ movie: DownloadedMovie) -> some View {
        HStack(spacing: 12) {
            LocalPosterView(image: viewModel.images[movie.id])
                .frame(width: 56, height: 56)

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title).font(.subheadline.bold())
                Text(viewModel.durationText(for: movie))
                    .font(.caption)
                    .foregroundStyle(.gray)
                Text(viewModel.fileSizeText(for: movie))
                    .font(.caption2)
                    .foregroundStyle(.red)
            }

            Spacer()

            Button {
                pendingDeleteMovie = movie
            } label: {
                Image(systemName: "trash")
                    .foregroundStyle(.red)
            }
            .buttonStyle(.plain)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "arrow.down.circle")
                .font(.system(size: 48))
                .foregroundStyle(.gray)
            Text("No Downloads")
                .font(.headline)
            Text("Movies you download will appear here.")
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

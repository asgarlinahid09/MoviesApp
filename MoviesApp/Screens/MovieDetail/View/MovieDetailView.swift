//
//  MovieDetailView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 24.09.26.
//

import SwiftUI

enum MovieDetailTab: String, CaseIterable {
    case trailers = "Trailers"
    case moreLikeThis = "More Like This"
    case reviews = "Reviews"
}

struct MovieDetailView: View {
    @Environment(MainCoordinator.self) private var coordinator
    @State private var selectedTab: MovieDetailTab = .trailers
    let viewModel: MovieDetailViewModel

    var body: some View {
        ScrollView {
            if let details = viewModel.details {
                VStack(alignment: .leading, spacing: 0) {
                    posterHeader
                    detailsBody(details)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .toolbarBackground(.hidden, for: .navigationBar)
        .overlay { loadingOverlay }
        .task { await viewModel.loadData() }
        .onAppear { viewModel.refreshSavedStatus() }
    }


    private var posterHeader: some View {
        MoviePosterView(posterURL: viewModel.posterURL, cornerRadius: 0)
            .frame(maxWidth: .infinity)
            .frame(height: 450)
            .clipped()
    }

    private func detailsBody(_ details: MovieDetailsDTO) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            titleRow(details)
            metaRow(details)
            playButton
            actionButtons
            overviewText(details)
            castSection
            tabSection
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 32)
    }

    private func titleRow(_ details: MovieDetailsDTO) -> some View {
        HStack {
            Text(details.title)
                .font(.title2.bold())
            Spacer()
            if let shareURL = viewModel.shareURL {
                ShareLink(item: shareURL, subject: Text(details.title)) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                        .foregroundStyle(.primary)
                }
            }
        }
    }

    private func metaRow(_ details: MovieDetailsDTO) -> some View {
        HStack(spacing: 8) {
            RatingBadge(rating: details.voteAverage)
            if let runtime = details.runtime {
                Text("\(runtime) minute")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            if !details.genres.isEmpty {
                Text(details.genres.map(\.name).joined(separator: ", "))
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
    }

    private var playButton: some View {
        Button {
            if let url = viewModel.primaryTrailerURL {
                UIApplication.shared.open(url)
            }
        } label: {
            Label("Play", systemImage: "play.fill")
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.red)
                .foregroundStyle(.white)
                .clipShape(Capsule())
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button {
                viewModel.toggleMyList()
            } label: {
                pillLabel(
                    title: viewModel.isSaved ? "Added" : "My List",
                    icon: viewModel.isSaved ? "checkmark" : "plus"
                )
            }

            Button {
                Task { await viewModel.toggleDownload() }
            } label: {
                pillLabel(
                    title: viewModel.isDownloaded ? "Downloaded" : "Download",
                    icon: viewModel.isDownloaded ? "checkmark.circle.fill" : "arrow.down.circle"
                )
            }
            .disabled(viewModel.isDownloading)
        }
    }

    private func pillLabel(title: String, icon: String) -> some View {
        Label(title, systemImage: icon)
            .font(.subheadline.bold())
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.gray.opacity(0.15))
            .foregroundStyle(.primary)
            .clipShape(Capsule())
    }

    private func overviewText(_ details: MovieDetailsDTO) -> some View {
        Text(details.overview)
            .font(.body)
            .foregroundStyle(.secondary)
    }

    @ViewBuilder
    private var castSection: some View {
        if !viewModel.cast.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Cast")
                    .font(.headline)
                castRow
            }
            .padding(.top, 8)
        }
    }

    private var castRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(viewModel.cast.prefix(10)) { member in
                    CastMemberView(
                        name: member.name,
                        profileURL: viewModel.castProfileURL(for: member)
                    )
                }
            }
        }
    }

    @ViewBuilder
    private var loadingOverlay: some View {
        if viewModel.isLoading {
            ProgressView()
        }
    }


    private var tabSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            tabPicker
            tabContent
        }
        .padding(.top, 16)
    }

    private var tabPicker: some View {
        Picker("", selection: $selectedTab) {
            ForEach(MovieDetailTab.allCases, id: \.self) { tab in
                Text(tab.rawValue).tag(tab)
            }
        }
        .pickerStyle(.segmented)
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .trailers: trailersSection
        case .moreLikeThis: moreLikeThisSection
        case .reviews: reviewsSection
        }
    }

    @ViewBuilder
    private var trailersSection: some View {
        if viewModel.videos.isEmpty {
            emptyTabMessage("Trailer tapılmadı")
        } else {
            VStack(spacing: 12) {
                ForEach(viewModel.videos) { video in
                    trailerRow(video)
                }
            }
        }
    }

    private func trailerRow(_ video: VideoDTO) -> some View {
        Group {
            if let url = viewModel.trailerURL(for: video) {
                Link(destination: url) {
                    HStack {
                        Image(systemName: "play.rectangle.fill")
                            .font(.title2)
                            .foregroundStyle(.red)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(video.name)
                                .font(.subheadline.bold())
                                .foregroundStyle(.primary)
                            Text("YouTube-da aç")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .foregroundStyle(.gray)
                    }
                    .padding(12)
                    .background(Color.gray.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }

    @ViewBuilder
    private var moreLikeThisSection: some View {
        if viewModel.similarMovies.isEmpty {
            emptyTabMessage("Oxşar film tapılmadı")
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.similarMovies.prefix(10)) { movie in
                        similarMovieCard(movie)
                    }
                }
            }
        }
    }

    private func similarMovieCard(_ movie: MovieDTO) -> some View {
        Button {
            coordinator.push(.movieDetail(id: movie.id))
        } label: {
            MovieCard(posterURL: viewModel.similarPosterURL(for: movie), rating: movie.voteAverage)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var reviewsSection: some View {
        if viewModel.reviews.isEmpty {
            emptyTabMessage("Rəy tapılmadı")
        } else {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(viewModel.reviews.prefix(5)) { review in
                    reviewCard(review)
                }
            }
        }
    }

    private func reviewCard(_ review: ReviewDTO) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(review.author)
                    .font(.subheadline.bold())
                if let rating = review.authorDetails.rating {
                    Spacer()
                    RatingBadge(rating: rating)
                }
            }
            Text(review.content)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(5)
        }
        .padding(12)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func emptyTabMessage(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(.gray)
    }
}

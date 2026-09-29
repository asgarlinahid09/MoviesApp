//
//  HomeView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 23.09.26.
//

import SwiftUI

struct HomeView: View {
    @Environment(MainCoordinator.self) private var coordinator

    var body: some View {
        @Bindable var viewModel = coordinator.homeViewModel

        ZStack(alignment: .top) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 100)
                    } else if let heroMovie = viewModel.topMovies.first {
                        HeroBannerView(
                            movie: heroMovie,
                            posterURL: viewModel.posterURL(for: heroMovie),
                            genreText: viewModel.genreText(for: heroMovie),
                            isSaved: viewModel.isSaved(heroMovie),
                            onMyListTap: { viewModel.toggleMyList(for: heroMovie) }
                        )
                        MovieSectionRow(
                            title: "Top 10 Movies This Week",
                            movies: viewModel.topMovies,
                            posterURL: viewModel.posterURL(for:),
                            onSeeAll: { coordinator.push(.movieList(.topMovies)) },
                            onSelect: { movie in coordinator.push(.movieDetail(id: movie.id)) }
                        )

                        MovieSectionRow(
                            title: "New Releases",
                            movies: viewModel.newReleases,
                            posterURL: viewModel.posterURL(for:),
                            onSeeAll: { coordinator.push(.movieList(.newReleases)) },
                            onSelect: { movie in coordinator.push(.movieDetail(id: movie.id)) }
                        )
                    }
                }
                .padding(.bottom, 100)
            }
            .ignoresSafeArea(edges: .top)

            topBar
        }
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.loadData()
        }
        .onAppear {
               viewModel.refreshSavedMovieIDs()
           }
    }

    private var topBar: some View {
        HStack {
            Text("M")
                .font(.system(size: 26, weight: .heavy))
                .foregroundStyle(.red)

            Spacer()

            HStack(spacing: 20) {
                Button {
                    coordinator.selectedTab = .explore
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.white)
                }

                Button {
                    coordinator.push(.notifications)
                } label: {
                    Image(systemName: "bell")
                        .foregroundStyle(.white)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

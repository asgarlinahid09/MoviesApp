//
//  MainScreenDestinations.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 25.09.26.
//

import SwiftUI

private struct MainScreenDestinations: ViewModifier {
    let coordinator: MainCoordinator

    func body(content: Content) -> some View {
        content.navigationDestination(for: MainScreen.self) { screen in
            switch screen {
            case .movieDetail(let id):
                MovieDetailView(viewModel: coordinator.movieDetailViewModel(for: id))
            case .movieList(let kind):
                MovieListView(viewModel: coordinator.movieListViewModel(for: kind))
            case .notifications:
                NotificationView(viewModel: coordinator.notificationViewModel)
            }
        }
    }
}

extension View {
    func mainScreenDestinations(coordinator: MainCoordinator) -> some View {
        modifier(MainScreenDestinations(coordinator: coordinator))
    }
}

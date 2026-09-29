//
//  MainCoordinatorView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 23.09.26.
//

import SwiftUI

struct MainCoordinatorView: View {
    @Bindable var coordinator: MainCoordinator

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            NavigationStack(path: $coordinator.path) {
                HomeView()
                    .mainScreenDestinations(coordinator: coordinator)
            }
            .tabItem { Label(localized("tab_home"), systemImage: "house.fill") }
            .tag(MainTab.home)

            ExploreView()
                .tabItem { Label(localized("tab_explore"), systemImage: "magnifyingglass") }
                .tag(MainTab.explore)

            MyListView(viewModel: coordinator.myListViewModel)
                .tabItem { Label(localized("tab_mylist"), systemImage: "bookmark.fill") }
                .tag(MainTab.myList)

            DownloadView(viewModel: coordinator.downloadViewModel)
                .tabItem { Label(localized("tab_download"), systemImage: "arrow.down.circle.fill") }
                .tag(MainTab.download)

            ProfileView(viewModel: coordinator.profileViewModel)
                .tabItem { Label(localized("tab_profile"), systemImage: "person.fill") }
                .tag(MainTab.profile)
        }
        .tint(.red)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color.white, for: .tabBar)
        .toolbar(
            (coordinator.path.isEmpty && coordinator.explorePath.isEmpty && coordinator.myListPath.isEmpty)
                ? .visible : .hidden,
            for: .tabBar
        )
        .environment(coordinator)
    }
}

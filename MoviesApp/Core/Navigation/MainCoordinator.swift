//
//  MainCoordinator.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 23.09.26.
//

import SwiftUI

enum MainTab {
    case home
    case explore
    case myList
    case download
    case profile
}

enum MainScreen: Hashable {
    case movieDetail(id: Int)
    case movieList(MovieListKind)
    case notifications
}

@Observable
final class MainCoordinator {
    var selectedTab: MainTab = .home
    var path = NavigationPath()
    var explorePath = NavigationPath()
    var myListPath = NavigationPath()
    let movieService: MovieServiceProtocol
    let myListService: MyListServiceProtocol
    let downloadService: DownloadServiceProtocol
    let authService: AuthServiceProtocol
    let biometricService: BiometricServiceProtocol
    let languageService: LanguageServiceProtocol

    var myListDidChange = 0

    @ObservationIgnored
    private(set) lazy var homeViewModel = HomeViewModel(movieService: movieService, myListService: myListService)

    @ObservationIgnored
    private(set) lazy var exploreViewModel = ExploreViewModel(movieService: movieService)

    @ObservationIgnored
    private(set) lazy var notificationViewModel = NotificationViewModel(movieService: movieService)

    @ObservationIgnored
    private(set) lazy var myListViewModel = MyListViewModel(movieService: movieService, myListService: myListService)

    @ObservationIgnored
    private(set) lazy var downloadViewModel = DownloadViewModel(downloadService: downloadService)

    @ObservationIgnored
    private(set) lazy var profileViewModel = ProfileViewModel(
        authService: authService,
        downloadService: downloadService,
        biometricService: biometricService,
        languageService: languageService
    )

    @ObservationIgnored
    private var movieListViewModels: [MovieListKind: MovieListViewModel] = [:]

    @ObservationIgnored
    private var movieDetailViewModels: [Int: MovieDetailViewModel] = [:]

    init(
        movieService: MovieServiceProtocol,
        myListService: MyListServiceProtocol,
        downloadService: DownloadServiceProtocol,
        authService: AuthServiceProtocol,
        biometricService: BiometricServiceProtocol,
        languageService: LanguageServiceProtocol
    ) {
        self.movieService = movieService
        self.myListService = myListService
        self.downloadService = downloadService
        self.authService = authService
        self.biometricService = biometricService
        self.languageService = languageService
    }

    func push(_ screen: MainScreen) {
        switch selectedTab {
        case .explore:
            explorePath.append(screen)
        case .myList:
            myListPath.append(screen)
        default:
            path.append(screen)
        }
    }

    func pop() {
        switch selectedTab {
        case .explore:
            if !explorePath.isEmpty { explorePath.removeLast() }
        case .myList:
            if !myListPath.isEmpty { myListPath.removeLast() }
        default:
            if !path.isEmpty { path.removeLast() }
        }
    }

    func movieListViewModel(for kind: MovieListKind) -> MovieListViewModel {
        if let existing = movieListViewModels[kind] { return existing }
        let viewModel = MovieListViewModel(kind: kind, movieService: movieService)
        movieListViewModels[kind] = viewModel
        return viewModel
    }

    func movieDetailViewModel(for id: Int) -> MovieDetailViewModel {
        if let existing = movieDetailViewModels[id] { return existing }
        let viewModel = MovieDetailViewModel(
            movieID: id,
            movieService: movieService,
            myListService: myListService,
            downloadService: downloadService
        )
        movieDetailViewModels[id] = viewModel
        return viewModel
    }

    func notifyMyListChanged() {
        myListDidChange += 1
    }
}

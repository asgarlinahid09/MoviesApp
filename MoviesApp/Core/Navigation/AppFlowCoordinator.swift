//
//  AppFlowCoordinator.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 17.09.26.
//

import Foundation

enum AppRoute {
    case launching
    case onboarding
    case auth
    case main
}

@Observable
final class AppFlowCoordinator {
    var route: AppRoute = .launching
    private(set) var authCoordinator: AuthCoordinator?
    private(set) var mainCoordinator: MainCoordinator?

    let authService: AuthServiceProtocol
    private let userDefaultsHelper: UserDefaultsHelper
    private let movieService: MovieServiceProtocol
    private let myListService: MyListServiceProtocol
    private let downloadService: DownloadServiceProtocol
    private let biometricService: BiometricServiceProtocol
    private let languageService: LanguageServiceProtocol

    private var hasSeenOnboarding: Bool {
        get { userDefaultsHelper.get(key: .hasSeenOnboarding) }
        set { userDefaultsHelper.save(key: .hasSeenOnboarding, value: newValue) }
    }

    init(
        authService: AuthServiceProtocol,
        userDefaultsHelper: UserDefaultsHelper,
        movieService: MovieServiceProtocol,
        myListService: MyListServiceProtocol,
        downloadService: DownloadServiceProtocol,
        biometricService: BiometricServiceProtocol,
        languageService: LanguageServiceProtocol
    ) {
        self.authService = authService
        self.userDefaultsHelper = userDefaultsHelper
        self.movieService = movieService
        self.myListService = myListService
        self.downloadService = downloadService
        self.biometricService = biometricService
        self.languageService = languageService
    }

    func start() async {
        try? await Task.sleep(for: .seconds(1.5))
        resolveRoute()
    }

    private func resolveRoute() {
        if authService.isUserLoggedIn {
            enterMainFlow()
        } else if !hasSeenOnboarding {
            route = .onboarding
        } else {
            enterAuthFlow()
        }
    }

    func finishOnboarding() {
        hasSeenOnboarding = true
        enterAuthFlow()
    }

    private func enterAuthFlow() {
        authCoordinator = AuthCoordinator(
            authService: authService,
            userDefaultsHelper: userDefaultsHelper
        )
        route = .auth
    }

    func userLoggedIn() {
        authCoordinator = nil
        enterMainFlow()
    }

    func userLoggedOut() {
        mainCoordinator = nil
        enterAuthFlow()
    }

    private func enterMainFlow() {
        mainCoordinator = MainCoordinator(
            movieService: movieService,
            myListService: myListService,
            downloadService: downloadService,
            authService: authService,
            biometricService: biometricService,
            languageService: languageService
        )
        route = .main
    }
}

//
//  MoviesAppApp.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 11.09.26.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import SwiftData

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        return true
    }
}

@main
struct MoviesAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    private let flow: AppFlowCoordinator
    private let modelContainer: ModelContainer

    init() {
        FirebaseApp.configure()

        if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            try? Auth.auth().signOut()
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }

        let authService: AuthServiceProtocol = FirebaseAuthService()
        let userDefaultsHelper: UserDefaultsHelper = UserDefaultsHelperImpl()
        let networkService: NetworkService = DefaultNetworkService()
        let movieService: MovieServiceProtocol = MovieService(networkService: networkService)
        let biometricService: BiometricServiceProtocol = BiometricService()
        let languageService: LanguageServiceProtocol = LanguageService()

        Bundle.setLanguage(languageService.currentLanguage.rawValue)

        do {
            modelContainer = try ModelContainer(for: SavedMovie.self, DownloadedMovie.self)
        } catch {
            fatalError("SwiftData container yaradıla bilmədi: \(error)")
        }

        let myListService: MyListServiceProtocol = MyListService(modelContext: modelContainer.mainContext)
        let downloadService: DownloadServiceProtocol = DownloadService(modelContext: modelContainer.mainContext)

        flow = AppFlowCoordinator(
            authService: authService,
            userDefaultsHelper: userDefaultsHelper,
            movieService: movieService,
            myListService: myListService,
            downloadService: downloadService,
            biometricService: biometricService,
            languageService: languageService
        )
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(flow)
        }
        .modelContainer(modelContainer)
    }
}

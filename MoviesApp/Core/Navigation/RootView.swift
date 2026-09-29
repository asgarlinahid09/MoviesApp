//
//  RootView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 17.09.26.
//

import SwiftUI

struct RootView: View {
    @Environment(AppFlowCoordinator.self) private var flow
    @AppStorage("isDarkModeOn") private var isDarkModeOn = false
    @AppStorage("selectedAppLanguage") private var languageRefreshKey = "en"
    @AppStorage("isFaceIDLockOn") private var isFaceIDLockOn = false
    @State private var isUnlocked = false

    var body: some View {
        Group {
            switch flow.route {
            case .launching:
                SplashScreenView()
            case .onboarding:
                OnboardingView(onFinish: flow.finishOnboarding)
            case .auth:
                if let authCoordinator = flow.authCoordinator {
                    AuthCoordinatorView(coordinator: authCoordinator)
                }
            case .main:
                if let mainCoordinator = flow.mainCoordinator {
                    if isFaceIDLockOn && !isUnlocked {
                        AppLockView(biometricService: mainCoordinator.biometricService) {
                            isUnlocked = true
                        }
                    } else {
                        MainCoordinatorView(coordinator: mainCoordinator)
                    }
                }
            }
        }
        .id(languageRefreshKey)
        .task { await flow.start() }
        .onChange(of: flow.authService.isUserLoggedIn) { _, isLoggedIn in
            if isLoggedIn { flow.userLoggedIn() } else { flow.userLoggedOut() }
        }
        .onChange(of: flow.route) { _, newRoute in
            if newRoute != .main { isUnlocked = false }
        }
        .preferredColorScheme(isDarkModeOn ? .dark : nil)
    }
}

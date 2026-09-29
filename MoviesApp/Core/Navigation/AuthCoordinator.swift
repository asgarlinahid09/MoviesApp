//
//  AuthCoordinator.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 15.09.26.
//

import SwiftUI

@Observable
final class AuthCoordinator {
    var path = NavigationPath()
    let authService: AuthServiceProtocol
    let userDefaultsHelper: UserDefaultsHelper

    @ObservationIgnored
    private(set) lazy var signInViewModel = SignInViewModel(
        authService: authService,
        userDefaultsHelper: userDefaultsHelper
    )

    @ObservationIgnored
    private(set) lazy var signUpViewModel = SignUpViewModel(
        authService: authService,
        userDefaultsHelper: userDefaultsHelper
    )

    init(authService: AuthServiceProtocol, userDefaultsHelper: UserDefaultsHelper) {
        self.authService = authService
        self.userDefaultsHelper = userDefaultsHelper
    }

    func push(_ screen: AuthScreen) {
        path.append(screen)
    }

    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}

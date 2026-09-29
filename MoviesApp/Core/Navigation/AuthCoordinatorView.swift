//
//  AuthCoordinatorView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 15.09.26.
//


import SwiftUI

enum AuthScreen: Hashable {
    case authOption
    case signIn
    case signUp
}

struct AuthCoordinatorView: View {
    @Bindable var coordinator: AuthCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            AuthOptionView()
                .navigationDestination(for: AuthScreen.self) { screen in
                    switch screen {
                    case .authOption:
                        AuthOptionView()
                    case .signIn:
                        SignInView()
                    case .signUp:
                        SignUpView()
                    }
                }
        }
        .environment(coordinator)
    }
}

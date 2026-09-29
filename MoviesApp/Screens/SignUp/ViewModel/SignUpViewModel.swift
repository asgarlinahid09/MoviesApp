//
//  SignUpViewModel.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 15.09.26.
//

import Foundation

@Observable
final class SignUpViewModel {
    var email = ""
    var password = ""
    var rememberMe = false
    var isLoading = false
    var errorMessage: String?

    private let authService: AuthServiceProtocol
    private let userDefaultsHelper: UserDefaultsHelper

    init(authService: AuthServiceProtocol, userDefaultsHelper: UserDefaultsHelper) {
        self.authService = authService
        self.userDefaultsHelper = userDefaultsHelper
        
    }

    var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty && password.count >= 6
    }

    @MainActor
    func signUp() async {
        guard isFormValid else { return }
        isLoading = true
        errorMessage = nil

        do {
            try await authService.signUp(email: email, password: password)
            isLoading = false
            updateRememberedEmail()
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }

    private func updateRememberedEmail() {
        if rememberMe {
            userDefaultsHelper.save(key: .rememberedEmail, value: email)
        } else {
            userDefaultsHelper.remove(key: .rememberedEmail)
        }
    }
}

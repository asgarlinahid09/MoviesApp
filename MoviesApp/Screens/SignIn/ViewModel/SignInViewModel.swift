//
//  SignInViewModel.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 15.09.26.
//

import Foundation

@Observable
final class SignInViewModel {
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

        let savedEmail: String = userDefaultsHelper.get(key: .rememberedEmail)
         if !savedEmail.isEmpty {
             email = savedEmail
             rememberMe = true
         }
     }

    var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty && password.count >= 6
    }

    @MainActor
    func signIn() async {
        guard isFormValid else {
            errorMessage = "Zəhmət olmasa email və şifrəni (min 6 simvol) düzgün daxil edin."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            try await authService.signIn(email: email, password: password)
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

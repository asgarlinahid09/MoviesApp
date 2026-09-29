//
//  SignUpView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 15.09.26.
//

import SwiftUI

struct SignUpView: View {
    @Environment(AuthCoordinator.self) private var coordinator

    var body: some View {
        @Bindable var viewModel = coordinator.signUpViewModel

        VStack(spacing: 24) {
            AuthHeaderView(title: "Create Your Account")

            VStack(spacing: 16) {
                AppTextField(placeholder: "Email", text: $viewModel.email, iconName: "envelope.fill")
                AppTextField(placeholder: "Password", text: $viewModel.password, isSecure: true, iconName: "lock.fill")
                RememberMeToggle(isOn: $viewModel.rememberMe)
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).errorMessageStyle()
            }

            AppButton(
                title: "Sign Up",
                isEnabled: viewModel.isFormValid,
                isLoading: viewModel.isLoading
            ) {
                Task { await viewModel.signUp() }
            }

            LabeledDivider(title: "or continue with")
            SocialAuthRow()

            Spacer()

            AuthSwitchFooter(question: "Already have an account?", actionTitle: "Sign In") {
                coordinator.push(.signIn)
            }
        }
        .padding(.horizontal, 24)
    }
}

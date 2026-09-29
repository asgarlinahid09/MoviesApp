//
//  SignInView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 15.09.26.
//

import SwiftUI


struct SignInView: View {
    @Environment(AuthCoordinator.self) private var coordinator

    var body: some View {
        @Bindable var viewModel = coordinator.signInViewModel

        VStack(spacing: 24) {
            AuthHeaderView(title: "Login to Your Account")

            VStack(spacing: 16) {
                AppTextField(placeholder: "Email", text: $viewModel.email, iconName: "envelope.fill")
                AppTextField(placeholder: "Password", text: $viewModel.password, isSecure: true, iconName: "lock.fill")
                RememberMeToggle(isOn: $viewModel.rememberMe)
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).errorMessageStyle()
            }

            AppButton(
                title: "Sign In",
                isEnabled: viewModel.isFormValid,
                isLoading: viewModel.isLoading
            ) {
                Task { await viewModel.signIn() }
            }

            Button("Forgot the password?") {
                // TODO bura bize lazim olmayacaq hele ki 
            }
            .font(.system(size: 15, weight: .medium))
            .foregroundStyle(.red)

            LabeledDivider(title: "or continue with")
            SocialAuthRow()

            Spacer()

            AuthSwitchFooter(question: "Don't have an account?", actionTitle: "Sign Up") {
                coordinator.push(.signUp)
            }
        }
        .padding(.horizontal, 24)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//
//  AuthOptionView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 14.09.26.
//


import SwiftUI

struct AuthOptionView: View {
    @Environment(AuthCoordinator.self) private var coordinator

    private let socialProviders: [(icon: String, title: String)] = [
        ("auth2", "Continue with Facebook"),
        ("auth3", "Continue with Google"),
        ("auth4", "Continue with Apple")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerImage
                title

                ForEach(socialProviders, id: \.icon) { provider in
                    SocialAuthButton(iconName: provider.icon, title: provider.title) {
                        
                    }
                }

                LabeledDivider(title: "or")

                AppButton(title: "Sign in with password") {
                    coordinator.push(.signIn)
                }

                AuthSwitchFooter(
                    question: "Don't have an account?",
                    actionTitle: "Sign up"
                ) {
                    coordinator.push(.signUp)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 60)
        }
    }

    private var headerImage: some View {
        Image(.aut1)
            .resizable()
            .frame(width: 200, height: 200)
            .clipShape(.circle)
    }

    private var title: some View {
        Text("Let's you in")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(.black)
    }
}


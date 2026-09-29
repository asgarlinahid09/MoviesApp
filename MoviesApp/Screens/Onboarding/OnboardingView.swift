//
//  OnboardingView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 11.09.26.

import SwiftUI

struct OnboardingView: View {
    let onFinish: () -> Void
    @State private var currentPage = 0

    private let onboardingImages = ["onboarding1", "onboarding2", "onboarding3", "onboarding4"]
    private var totalPages: Int { onboardingImages.count }

    var body: some View {
        ZStack {
            pagingImages
            gradientOverlay
            contentOverlay
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }

    private var pagingImages: some View {
        TabView(selection: $currentPage) {
            ForEach(0..<totalPages, id: \.self) { index in
                Image(onboardingImages[index])
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }

    private var gradientOverlay: some View {
        LinearGradient(
            colors: [.clear, .black.opacity(0.6), .black.opacity(0.95)],
            startPoint: .top,
            endPoint: .bottom
        )
        .allowsHitTesting(false)
    }



    private var contentOverlay: some View {
        VStack(spacing: 20) {
            Spacer()
            titleTexts
            PageIndicator(totalPages: totalPages, currentPage: currentPage)
                .padding(.vertical, 10)
            continueButton
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 20)
    }

    private var titleTexts: some View {
        VStack(spacing: 20) {
            Text("Welcome to Mova")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            Text("The best movie streaming app of the century to make your days great!")
                .font(.body)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
        }
    }

    private var continueButton: some View {
        Button(action: goToNextPageOrFinish) {
            Text(currentPage == totalPages - 1 ? "Get Started" : "Continue")
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .clipShape(Capsule())
        }
    }


    private func goToNextPageOrFinish() {
        if currentPage < totalPages - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage += 1
            }
        } else {
            onFinish()
        }
    }
}

//
//  SplashScreenView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 11.09.26.
//



import SwiftUI

struct SplashScreenView: View {
    private let letters = Array("Mova")
    @State private var lettersVisible = false
    @State private var showGlow = false
    @State private var showProgress = false

    var body: some View {
        ZStack {
            Color.white

            VStack {
                Spacer()
                animatedWordmark
                Spacer()
                progressIndicator
            }
        }
        .ignoresSafeArea()
        .task {
            await runIntroSequence()
        }
    }


    private var animatedWordmark: some View {
        HStack(spacing: 2) {
            ForEach(letters.indices, id: \.self) { index in
                letterView(letters[index], index: index)
            }
        }
        .shadow(color: .red.opacity(showGlow ? 0.6 : 0), radius: showGlow ? 24 : 0)
    }

    private func letterView(_ letter: Character, index: Int) -> some View {
        Text(String(letter))
            .font(.system(size: 64, weight: .heavy))
            .foregroundStyle(.red)
            .scaleEffect(lettersVisible ? 1 : 2.4)
            .opacity(lettersVisible ? 1 : 0)
            .animation(
                .spring(response: 0.55, dampingFraction: 0.6).delay(Double(index) * 0.12),
                value: lettersVisible
            )
    }

    @ViewBuilder
    private var progressIndicator: some View {
        if showProgress {
            ProgressView()
                .scaleEffect(2.5)
                .tint(.red)
                .padding(.bottom, 50)
                .transition(.opacity)
        } else {
            Color.clear
                .frame(height: 40)
                .padding(.bottom, 50)
        }
    }


    private func runIntroSequence() async {
        lettersVisible = true

        try? await Task.sleep(for: .seconds(0.9))
        withAnimation(.easeOut(duration: 0.4)) {
            showGlow = true
        }

        try? await Task.sleep(for: .seconds(0.4))
        withAnimation(.easeOut(duration: 0.3)) {
            showGlow = false
            showProgress = true
        }
    }
}

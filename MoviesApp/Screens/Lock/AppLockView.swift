//
//  AppLockView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 29.09.26.
//

import SwiftUI

struct AppLockView: View {
    let biometricService: BiometricServiceProtocol
    let onUnlock: () -> Void
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "faceid")
                .font(.system(size: 64))
                .foregroundStyle(.red)

            Text("App Locked")
                .font(.title2.bold())

            if let errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
            }

            Button {
                Task { await authenticate() }
            } label: {
                Text("Unlock with Face ID")
                    .font(.subheadline.bold())
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.red)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .task {
            await authenticate()
        }
    }

    private func authenticate() async {
        do {
            let success = try await biometricService.authenticate()
            if success {
                onUnlock()
            }
        } catch {
            errorMessage = "Authentication failed. Try again."
        }
    }
}

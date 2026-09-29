//
//  ChangePasswordView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 25.09.26.
//

import SwiftUI

struct ChangePasswordView: View {
    @Bindable var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var newPassword = ""
    @State private var confirmPassword = ""

    private var isValid: Bool {
        newPassword.count >= 6 && newPassword == confirmPassword
    }

    var body: some View {
        Form {
            Section("New Password") {
                SecureField("At least 6 characters", text: $newPassword)
                SecureField("Confirm password", text: $confirmPassword)
            }

            if !confirmPassword.isEmpty && newPassword != confirmPassword {
                Text("Passwords do not match")
                    .font(.caption)
                    .foregroundStyle(.red)
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    Task {
                        let success = await viewModel.changePassword(newPassword: newPassword)
                        if success { dismiss() }
                    }
                }
                .disabled(!isValid || viewModel.isSaving)
            }
        }
    }
}

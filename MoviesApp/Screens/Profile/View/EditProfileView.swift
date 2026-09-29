//
//  EditProfileView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 25.09.26.
//

import SwiftUI

struct EditProfileView: View {
    @Bindable var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section("Name") {
                TextField("Your name", text: $viewModel.displayName)
            }

            Section {
                Text(viewModel.email)
                    .foregroundStyle(.gray)
            } header: {
                Text("Email")
            } footer: {
                Text("Email address cannot be changed here.")
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    Task {
                        await viewModel.saveDisplayName()
                        if viewModel.errorMessage == nil {
                            dismiss()
                        }
                    }
                }
                .disabled(viewModel.isSaving)
            }
        }
    }
}

//
//  SecurityView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 29.09.26.
//

import SwiftUI

struct SecurityView: View {
    @Bindable var viewModel: ProfileViewModel

    var body: some View {
        List {
            if viewModel.isBiometricAvailable {
                HStack {
                    Label("Face ID", systemImage: "faceid")
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { viewModel.isFaceIDLockOn },
                        set: { _ in Task { await viewModel.toggleFaceIDLock() } }
                    ))
                    .labelsHidden()
                }
            }

            NavigationLink {
                ChangePasswordView(viewModel: viewModel)
            } label: {
                Label("Change Password", systemImage: "lock")
            }
        }
        .navigationTitle("Security")
        .navigationBarTitleDisplayMode(.inline)
    }
}

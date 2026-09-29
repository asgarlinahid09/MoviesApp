//
//  DownloadSettingsView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 29.09.26.
//

import SwiftUI

struct DownloadSettingsView: View {
    @Bindable var viewModel: ProfileViewModel
    @State private var showDeleteAllConfirmation = false

    var body: some View {
        List {
            HStack {
                Label("Downloaded Movies", systemImage: "film")
                Spacer()
                Text("\(viewModel.downloadsCount)")
                    .foregroundStyle(.gray)
            }
            HStack {
                Label("Storage Used", systemImage: "internaldrive")
                Spacer()
                Text(viewModel.downloadsSizeText)
                    .foregroundStyle(.gray)
            }
            Button(role: .destructive) {
                showDeleteAllConfirmation = true
            } label: {
                Label("Delete All Downloads", systemImage: "trash")
            }
        }
        .navigationTitle("Download")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete All Downloads", isPresented: $showDeleteAllConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Yes, Delete", role: .destructive) {
                viewModel.deleteAllDownloads()
            }
        } message: {
            Text("Are you sure you want to delete all downloaded movies?")
        }
    }
}

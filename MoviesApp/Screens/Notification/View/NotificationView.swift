//
//  NotificationView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 23.09.26.
//

import SwiftUI

struct NotificationView: View {
    let viewModel: NotificationViewModel

    var body: some View {
        List(viewModel.items) { item in
            HStack(spacing: 12) {
                MoviePosterView(posterURL: item.posterURL)
                    .frame(width: 56, height: 56)

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.subheadline.bold())
                    Text(item.dateText)
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Text("New Release")
                        .font(.caption2.bold())
                        .foregroundStyle(.red)
                }

                Spacer()
            }
        }
        .listStyle(.plain)
        .navigationTitle("Notification")
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .task {
            await viewModel.loadData()
        }
    }
}

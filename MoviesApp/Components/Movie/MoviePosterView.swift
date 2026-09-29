//
//  MoviePosterView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 23.09.26.
//

import SwiftUI

struct MoviePosterView: View {
    let posterURL: URL?
    var cornerRadius: CGFloat = 12

    var body: some View {
        Group {
            if let posterURL {
                AsyncImage(url: posterURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .frame(maxWidth: .infinity)
                            .frame(maxHeight: .infinity)
                    case .failure:
                        placeholder
                    case .empty:
                        placeholder.overlay(ProgressView())
                    @unknown default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    private var placeholder: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.gray.opacity(0.2))
    }
}

#Preview {
    HStack(spacing: 16) {
        MoviePosterView(posterURL: nil)
            .frame(width: 130, height: 160)
        
        MoviePosterView(posterURL: URL(string: "https://image.tmdb.org/t/p/w500/ngl2FKBlU4fhbdsrtdom9LVLBXw.jpg"))
            .frame(width: 130, height: 160)
    }
    .padding()
}

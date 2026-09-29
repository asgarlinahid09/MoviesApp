//
//  HeroBannerView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 23.09.26.
//

import SwiftUI

struct HeroBannerView: View {
    let movie: MovieDTO
    let posterURL: URL?
    let genreText: String
    let isSaved: Bool
    let onMyListTap: () -> Void

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            MoviePosterView(posterURL: posterURL, cornerRadius: 0)
                .frame(maxWidth: .infinity)
                .frame(height: 450)
                .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.85)],
                startPoint: .top,
                endPoint: .bottom
            )
            .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.title.bold())
                    .foregroundStyle(.white)

                if !genreText.isEmpty {
                    Text(genreText)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                }

                HStack(spacing: 12) {
                     Button {
                         // TODO: trailer aç
                     } label: {
                         Label("Play", systemImage: "play.fill")
                             .font(.subheadline.bold())
                             .padding(.horizontal, 16)
                             .padding(.vertical, 8)
                             .background(Color.red)
                             .foregroundStyle(.white)
                             .clipShape(Capsule())
                     }

                     Button(action: onMyListTap) {
                         Label(isSaved ? "Added" : "My List", systemImage: isSaved ? "checkmark" : "plus")
                             .font(.subheadline.bold())
                             .padding(.horizontal, 16)
                             .padding(.vertical, 8)
                             .background(.white.opacity(0.2))
                             .foregroundStyle(.white)
                             .clipShape(Capsule())
                     }
                 }
                .padding(.top, 4)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .frame(height: 420)
    }
}

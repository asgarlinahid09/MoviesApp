//
//  CastMemberView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 24.09.26.
//

import SwiftUI

struct CastMemberView: View {
    let name: String
    let profileURL: URL?

    var body: some View {
        VStack(spacing: 6) {
            MoviePosterView(posterURL: profileURL, cornerRadius: 32)
                .frame(width: 64, height: 64)
                .clipShape(Circle())

            Text(name)
                .font(.caption)
                .lineLimit(1)
                .frame(width: 70)
        }
    }
}

#Preview {
    CastMemberView(
        name: "Tom Holland",
        profileURL: URL(string: "https://image.tmdb.org/t/p/w185/ngl2FKBlU4fhbdsrtdom9LVLBXw.jpg")
    )
}

//
//  RatingBadge.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 23.09.26.
//

import SwiftUI

struct RatingBadge: View {
    let rating: Double

    var body: some View {
        Text(String(format: "%.1f", rating))
            .font(.system(size: 11, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(Color.red)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

#Preview {
    RatingBadge(rating: 9.8)
}

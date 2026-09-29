//
//  LocalPosterView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 25.09.26.
//

import SwiftUI

struct LocalPosterView: View {
    let image: UIImage?
    var cornerRadius: CGFloat = 12

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
            } else {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.gray.opacity(0.2))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

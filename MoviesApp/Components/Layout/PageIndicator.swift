//
//  PageIndicator.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 18.09.26.
//

import SwiftUI

struct PageIndicator: View {
    let totalPages: Int
    let currentPage: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Capsule()
                    .fill(currentPage == index ? Color.red : Color.gray.opacity(0.5))
                    .frame(width: currentPage == index ? 24 : 8, height: 8)
                    .animation(.spring(), value: currentPage)
            }
        }
    }
}

//
//  LabeledDivider.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 15.09.26.
//

import SwiftUI

struct LabeledDivider: View {
    let title: String
    var body: some View {
        HStack(spacing: 16) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color(.separator))
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)
                .lineLimit(1)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color(.separator))
        }
    }
}


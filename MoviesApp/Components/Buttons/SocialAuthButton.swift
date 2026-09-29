//
//  SocialAuthButton.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 15.09.26.
//

import SwiftUI

struct SocialAuthButton: View {
    let iconName: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(iconName)
                    .resizable()
                    .clipShape(.circle)
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
            }
        }
        .buttonStyle(.plain) 
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

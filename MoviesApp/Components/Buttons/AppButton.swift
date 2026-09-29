//
//  AppButton.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 15.09.26.
//

import SwiftUI

enum ButtonVariant{
    case primary
    case secondary
}

struct PrimaryButtonStyle: ButtonStyle {
    let variant: ButtonVariant
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16,weight: .semibold))
            .foregroundStyle(variant == .primary ? .white : .red)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(variant == .primary ? .red : .red.opacity(0.1))
            .clipShape(.capsule)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
    
}
struct AppButton: View {
    let title: String
    var variant: ButtonVariant = .primary
    var isEnabled: Bool = true
    var isLoading: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            if isLoading {
                ProgressView()
                    .tint(variant == .primary ? .white : .red)
            } else {
                Text(title)
            }
        }
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1 : 0.5)
        .buttonStyle(PrimaryButtonStyle(variant: variant))
    }
}

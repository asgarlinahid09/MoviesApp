//
//  View+ErrorMessage.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 18.09.26.
//

import SwiftUI

private struct ErrorMessageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundStyle(.red)
            .multilineTextAlignment(.center)
    }
}

extension View {
    func errorMessageStyle() -> some View {
        modifier(ErrorMessageModifier())
    }
}

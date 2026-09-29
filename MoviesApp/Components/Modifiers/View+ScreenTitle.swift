//
//  View+ScreenTitle.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 18.09.26.
//

import SwiftUI

private struct ScreenTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .bold()
    }
}

extension View {
    func screenTitle() -> some View {
        modifier(ScreenTitleModifier())
    }
}

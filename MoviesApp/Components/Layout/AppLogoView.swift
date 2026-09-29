//
//  AppLogoView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 16.09.26.
//

import SwiftUI

struct AppLogoView: View {
    let title: String
    var size: CGFloat = 200
    var body: some View {
        Text(title)
            .font(.system(size: size, weight: .bold))
            .foregroundStyle(.red)
    }
}

#Preview {
    AppLogoView(title: "M")
}

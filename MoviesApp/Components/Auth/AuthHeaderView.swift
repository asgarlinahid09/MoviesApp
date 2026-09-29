//
//  AuthHeaderView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 18.09.26.
//

import SwiftUI

struct AuthHeaderView: View {
    let title: String

    var body: some View {
        VStack(spacing: 12) {
            AppLogoView(title: "M", size: 150)
            Text(title)
                .screenTitle()
        }
        .padding(.top, 40)
    }
}

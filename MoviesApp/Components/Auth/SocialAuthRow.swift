//
//  SocialAuthRow.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 18.09.26.
//

import SwiftUI
struct SocialAuthRow: View {
    var onFacebookTap: () -> Void = {}
    var onGoogleTap: () -> Void = {}
    var onAppleTap: () -> Void = {}

    var body: some View {
        HStack(spacing: 40) {
            SocialIconButton(iconName: "auth2", action: onFacebookTap)
            SocialIconButton(iconName: "auth3", action: onGoogleTap)
            SocialIconButton(iconName: "auth4", action: onAppleTap)
        }
    }
}

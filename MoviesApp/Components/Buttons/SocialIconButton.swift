//
//  SocialIconButton.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 15.09.26.
//

import SwiftUI

struct SocialIconButton: View {
    let iconName: String
    let action: () -> ()
    var body: some View {
        Button(action: action) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
            
        }
    }
}



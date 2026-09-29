//
//  AuthSwitchFooter.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 18.09.26.
//

import SwiftUI
struct AuthSwitchFooter: View {
    let question: String
    let actionTitle: String
    let action: () -> Void

    var body: some View {
        HStack {
            Text(question).foregroundStyle(.gray)
            Button(actionTitle, action: action)
                .bold()
                .foregroundStyle(.red)
        }
        .font(.subheadline)
        .padding(.bottom, 16)
    }
}

//
//  LanguagePickerView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 29.09.26.
//

import SwiftUI

struct LanguagePickerView: View {
    @Bindable var viewModel: ProfileViewModel

    var body: some View {
        List(AppLanguage.allCases) { language in
            Button {
                viewModel.selectedLanguage = language
            } label: {
                HStack {
                    Text(language.displayName)
                        .foregroundStyle(.primary)
                    Spacer()
                    if viewModel.selectedLanguage == language {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .navigationTitle("Language")
        .navigationBarTitleDisplayMode(.inline)
    }
}

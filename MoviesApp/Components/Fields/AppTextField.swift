//
//  AppTextField.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 15.09.26.
//

import SwiftUI

struct AppTextField: View {
    

    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var iconName: String? = nil
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            
            HStack(spacing: 12){
                if let iconName {
                    Image(systemName: iconName)
                        .foregroundStyle(.secondary)
                }
                
                if isSecure && !isPasswordVisible {
                    SecureField(placeholder, text: $text)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } else {
                    TextField(placeholder, text: $text)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    
                }
                
                if isSecure {
                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                            .foregroundStyle(.secondary)
                    }
                    
                }
                
            }
            
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground))
            )
        }
    }
}


#Preview {
    struct PreviewWrapper: View {
        @State private var email = ""
        @State private var password = ""
        
        var body: some View {
            VStack(spacing: 20) {
                AppTextField(
                    placeholder: "Email ünvanınızı daxil edin",
                    text: $email,
                    iconName: "envelope.fill"
                )
                
                AppTextField(
                    placeholder: "Şifrənizi daxil edin",
                    text: $password,
                    isSecure: true,
                    iconName: "lock.fill"
                )
            }
            .padding()
        }
    }
    
    return PreviewWrapper()
}

//
//  RememberMeToggle.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 21.09.26.
//

import SwiftUI

struct RememberMeToggle: View {
    @Binding var isOn: Bool

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            HStack(spacing: 8) {
                checkbox
                Text("Remember me")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.primary)
            }
        }
        .buttonStyle(.plain)
    }

    private var checkbox: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(isOn ? Color.red : Color.clear)
            .frame(width: 20, height: 20)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(isOn ? Color.red : Color.gray.opacity(0.4), lineWidth: 1.5)
            )
            .overlay {
                if isOn {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
    }
}

#Preview {
    @Previewable @State var isOn = false
    RememberMeToggle(isOn: $isOn)
}
//// 1) Ən sadə (indi tövsiyə edirəm, sənin cəhd etdiyin forma)
//#Preview {
//    @Previewable @State var isOn = false
//    RememberMeToggle(isOn: $isOn)
//}
//
//// 2) Statik, interaktiv olmayan (sürətli görünüş yoxlaması üçün)
//#Preview {
//    RememberMeToggle(isOn: .constant(true))
//}


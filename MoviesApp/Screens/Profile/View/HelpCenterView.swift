//
//  HelpCenterView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 29.09.26.
//

import SwiftUI

struct HelpCenterView: View {
    var body: some View {
        List {
            Section("FAQ") {
                Text("How do I download a movie?")
                Text("How do I add a movie to My List?")
                Text("How do I change my password?")
            }
        }
        .navigationTitle("Help Center")
        .navigationBarTitleDisplayMode(.inline)
    }
}

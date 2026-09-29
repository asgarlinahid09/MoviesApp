//
//  ProfileView.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 25.09.26.
//

import SwiftUI

struct ProfileView: View {
    @Environment(MainCoordinator.self) private var coordinator
    @Bindable var viewModel: ProfileViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                topBar
                settingsList
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            viewModel.refresh()
        }
    }


    private var topBar: some View {
        HStack {
            Text("M")
                .font(.system(size: 22, weight: .heavy))
                .foregroundStyle(.red)
            Text(localized("profile_title"))
                .font(.headline)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }

    private var settingsList: some View {
        List {
            profileHeaderSection
            settingsSection
            logoutSection
        }
        .listStyle(.plain)
    }


    private var profileHeaderSection: some View {
        Section {
            profileHeader
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
        }
    }

    private var profileHeader: some View {
        VStack(spacing: 8) {
            avatarWithEditBadge
            if !viewModel.displayName.isEmpty {
                Text(viewModel.displayName)
                    .font(.headline)
            }
            Text(viewModel.email)
                .font(.caption)
                .foregroundStyle(.gray)

            premiumBanner
                .padding(.top, 12)
        }
    }

    private var avatarWithEditBadge: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 88))
                .foregroundStyle(.gray)

            Image(systemName: "pencil.circle.fill")
                .font(.system(size: 24))
                .foregroundStyle(.red)
        }
    }

    private var premiumBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "crown.fill")
                .font(.title2)
                .foregroundStyle(.red)

            VStack(alignment: .leading, spacing: 2) {
                Text("Join Premium!")
                    .font(.subheadline.bold())
                    .foregroundStyle(.red)
                Text("Enjoy watching Full-HD movies, without restrictions and without ads")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }

            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.red.opacity(0.5))
        }
        .padding(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.red, lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }

    private var settingsSection: some View {
        Section {
            editProfileRow
            notificationRow
            downloadRow
            securityRow
            languageRow
            darkModeToggle
            helpCenterRow
        }
    }

    private var editProfileRow: some View {
        NavigationLink {
            EditProfileView(viewModel: viewModel)
        } label: {
            Label(localized("profile_edit_profile"), systemImage: "person")
        }
    }

    private var notificationRow: some View {
        NavigationLink {
            NotificationView(viewModel: coordinator.notificationViewModel)
        } label: {
            Label("Notification", systemImage: "bell")
        }
    }

    private var downloadRow: some View {
        NavigationLink {
            DownloadSettingsView(viewModel: viewModel)
        } label: {
            Label(localized("tab_download"), systemImage: "arrow.down.circle")
        }
    }

    private var securityRow: some View {
        NavigationLink {
            SecurityView(viewModel: viewModel)
        } label: {
            Label("Security", systemImage: "checkmark.shield")
        }
    }

    private var languageRow: some View {
        NavigationLink {
            LanguagePickerView(viewModel: viewModel)
        } label: {
            HStack {
                Label("Language", systemImage: "globe")
                Spacer()
                Text(viewModel.selectedLanguage.displayName)
                    .foregroundStyle(.gray)
            }
        }
    }

    private var darkModeToggle: some View {
        Toggle(isOn: $viewModel.isDarkModeOn) {
            Label("Dark Mode", systemImage: "eye")
        }
    }

    private var helpCenterRow: some View {
        NavigationLink {
            HelpCenterView()
        } label: {
            Label("Help Center", systemImage: "info.circle")
        }
    }

    private var logoutSection: some View {
        Section {
            Button(role: .destructive) {
                viewModel.logout()
            } label: {
                Label(localized("profile_logout"), systemImage: "rectangle.portrait.and.arrow.right")
            }
        }
    }
}

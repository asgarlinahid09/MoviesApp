//
//  ProfileViewModel.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 25.09.26.
//

import Foundation

@Observable
final class ProfileViewModel {
    private let authService: AuthServiceProtocol
    private let downloadService: DownloadServiceProtocol
    private let biometricService: BiometricServiceProtocol
    private let languageService: LanguageServiceProtocol

    var email: String = ""
    var displayName: String = ""
    var downloadsCount: Int = 0
    var downloadsSizeText: String = "0 MB"
    var isSaving = false
    var errorMessage: String?

    var isBiometricAvailable: Bool {
        biometricService.isAvailable
    }

    var isFaceIDLockOn: Bool {
        get { UserDefaults.standard.bool(forKey: "isFaceIDLockOn") }
        set { UserDefaults.standard.set(newValue, forKey: "isFaceIDLockOn") }
    }

    var isDarkModeOn: Bool {
        get { UserDefaults.standard.bool(forKey: "isDarkModeOn") }
        set { UserDefaults.standard.set(newValue, forKey: "isDarkModeOn") }
    }

    var selectedLanguage: AppLanguage {
        get { languageService.currentLanguage }
        set { languageService.setLanguage(newValue) }
    }

    init(
        authService: AuthServiceProtocol,
        downloadService: DownloadServiceProtocol,
        biometricService: BiometricServiceProtocol,
        languageService: LanguageServiceProtocol
    ) {
        self.authService = authService
        self.downloadService = downloadService
        self.biometricService = biometricService
        self.languageService = languageService
    }

    func refresh() {
        email = authService.currentUserEmail ?? "—"
        displayName = authService.currentUserDisplayName ?? ""

        let downloads = downloadService.fetchAll()
        downloadsCount = downloads.count
        let totalBytes = downloads.reduce(Int64(0)) { $0 + $1.fileSizeBytes }
        downloadsSizeText = ByteCountFormatter.string(fromByteCount: totalBytes, countStyle: .file)
    }

    func saveDisplayName() async {
        let trimmed = displayName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        isSaving = true
        errorMessage = nil
        do {
            try await authService.updateDisplayName(trimmed)
        } catch {
            errorMessage = error.localizedDescription
        }
        isSaving = false
    }

    func changePassword(newPassword: String) async -> Bool {
        isSaving = true
        errorMessage = nil
        do {
            try await authService.updatePassword(newPassword)
            isSaving = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isSaving = false
            return false
        }
    }

    func toggleFaceIDLock() async {
        if isFaceIDLockOn {
            isFaceIDLockOn = false
            return
        }
        do {
            let success = try await biometricService.authenticate()
            if success {
                isFaceIDLockOn = true
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteAllDownloads() {
        for movie in downloadService.fetchAll() {
            downloadService.remove(movieID: movie.id)
        }
        refresh()
    }

    func logout() {
        try? authService.signOut()
    }
}

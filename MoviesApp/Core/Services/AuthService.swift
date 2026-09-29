//
//  AuthService.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 15.09.26.
//

import Foundation
import FirebaseAuth

protocol AuthServiceProtocol: AnyObject {
    var isUserLoggedIn: Bool { get }
    var currentUserEmail: String? { get }
    var currentUserID: String? { get }
    var currentUserDisplayName: String? { get }
    func signIn(email: String, password: String) async throws
    func signUp(email: String, password: String) async throws
    func signOut() throws
    func updateDisplayName(_ name: String) async throws
    func updatePassword(_ newPassword: String) async throws
}

@Observable
final class FirebaseAuthService: AuthServiceProtocol {
    private(set) var isUserLoggedIn: Bool
    private var authStateHandle: AuthStateDidChangeListenerHandle?

    var currentUserEmail: String? {
        Auth.auth().currentUser?.email
    }

    var currentUserID: String? {
        Auth.auth().currentUser?.uid
    }

    var currentUserDisplayName: String? {
        Auth.auth().currentUser?.displayName
    }

    init() {
        isUserLoggedIn = Auth.auth().currentUser != nil
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isUserLoggedIn = user != nil
        }
    }

    deinit {
        if let authStateHandle {
            Auth.auth().removeStateDidChangeListener(authStateHandle)
        }
    }

    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }

    func signUp(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func updateDisplayName(_ name: String) async throws {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        try await changeRequest?.commitChanges()
    }

    func updatePassword(_ newPassword: String) async throws {
        try await Auth.auth().currentUser?.updatePassword(to: newPassword)
    }
}

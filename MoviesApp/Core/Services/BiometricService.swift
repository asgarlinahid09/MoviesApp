//
//  BiometricService.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 25.09.26.
//

import Foundation
import LocalAuthentication

protocol BiometricServiceProtocol: AnyObject {
    var isAvailable: Bool { get }
    func authenticate() async throws -> Bool
}

final class BiometricService: BiometricServiceProtocol {
    var isAvailable: Bool {
        let context = LAContext()
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }

    func authenticate() async throws -> Bool {
        let context = LAContext()
        return try await context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Confirm your identity to enable Face ID lock"
        )
    }
}

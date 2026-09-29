//
//  LanguageService.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 29.09.26.
//

import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case azerbaijani = "az"
    case english = "en"
    case russian = "ru"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .azerbaijani: return "Azərbaycan"
        case .english: return "English"
        case .russian: return "Русский"
        }
    }
}

protocol LanguageServiceProtocol: AnyObject {
    var currentLanguage: AppLanguage { get }
    func setLanguage(_ language: AppLanguage)
}

final class LanguageService: LanguageServiceProtocol {
    private let key = "selectedAppLanguage"

    var currentLanguage: AppLanguage {
        get {
            guard let raw = UserDefaults.standard.string(forKey: key),
                  let language = AppLanguage(rawValue: raw) else {
                return .english
            }
            return language
        }
        set { }
    }

    func setLanguage(_ language: AppLanguage) {
        UserDefaults.standard.set(language.rawValue, forKey: key)
        Bundle.setLanguage(language.rawValue)
    }
}

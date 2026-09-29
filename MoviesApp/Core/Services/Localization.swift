//
//  Localization.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 29.09.26.
//

import Foundation

func localized(_ key: String) -> String {
    let languageCode = UserDefaults.standard.string(forKey: "selectedAppLanguage") ?? "en"

    guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
          let bundle = Bundle(path: path) else {
        return NSLocalizedString(key, comment: "")
    }

    return bundle.localizedString(forKey: key, value: nil, table: nil)
}

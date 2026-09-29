//
//  BundleLanguageSwizzle.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 29.09.26.
//

import Foundation
import ObjectiveC

private var bundleKey: UInt8 = 0

final class PrivateBundle: Bundle, @unchecked Sendable {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
              let languageBundle = Bundle(path: path) else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return languageBundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    static func setLanguage(_ languageCode: String) {
        object_setClass(Bundle.main, PrivateBundle.self)

        let path = Bundle.main.path(forResource: languageCode, ofType: "lproj")
        objc_setAssociatedObject(Bundle.main, &bundleKey, path, .OBJC_ASSOCIATION_RETAIN)
    }
}

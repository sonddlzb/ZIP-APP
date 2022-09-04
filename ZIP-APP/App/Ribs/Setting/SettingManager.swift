//
//  SettingManager.swift
//  Zip
//
//  Created by đào sơn on 01/09/2022.
//

import Foundation

private struct Const {
    static let passwordKey = "password"
    static let defaultPhotoSizeKey = "defaultPhotoSize"
}

class SettingManager {

    func savePassword(password: String) {
        UserDefaults.standard.set(password, forKey: Const.passwordKey)
    }

    func deleteCurrentPassword() {
        guard self.hasPassword() else {
            return
        }

        UserDefaults.standard.removeObject(forKey: Const.passwordKey)
    }

    func currentPassword() -> String? {
        return UserDefaults.standard.string(forKey: Const.passwordKey)
    }

    func hasPassword() -> Bool {
        return UserDefaults.standard.string(forKey: Const.passwordKey) != nil
    }

    func saveDefaultPhotoSize(defaultPhotoSize: DefaultPhotoSize) {
        UserDefaults.standard.set(defaultPhotoSize.rawValue, forKey: Const.defaultPhotoSizeKey)
    }

    func currentDefaultPhotoSize() -> DefaultPhotoSize {
        return DefaultPhotoSize(rawValue: UserDefaults.standard.integer(forKey: Const.defaultPhotoSizeKey)) ?? .original
    }
}

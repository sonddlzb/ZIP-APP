//
//  CreatePasswordViewModel.swift
//  Zip
//
//  Created by đào sơn on 31/08/2022.
//

import Foundation
import UIKit

private struct Const {
    static let defaultEnterPassword = ""
    static let defaultConfirmPassword = ""
}

enum PasswordValidatedResult {
    case empty, invalid, valid
}
struct CreatePasswordViewModel {
    var enterPassword: String
    var confirmPassword: String
    var invalidContent = "Invalid password"
    var settingManager = SettingManager()
    func validatePassword() -> PasswordValidatedResult {
        if enterPassword.isEmpty || confirmPassword.isEmpty {
            return .empty
        } else if enterPassword != confirmPassword {
            return .invalid
        } else {
            return .valid
        }
    }

    init(enterPassword: String = Const.defaultEnterPassword, confirmPassword: String = Const.defaultConfirmPassword) {
        self.enterPassword = enterPassword
        self.confirmPassword = confirmPassword
    }

    mutating func updatePassword(enterPassword: String, confirmPassword: String) {
        self.enterPassword = enterPassword
        self.confirmPassword = confirmPassword
    }

    func createButtonColor() -> UIColor? {
        return validatePassword() == .empty ? UIColor(rgb: 0xE0E0E0) : UIColor(rgb: 0xFF6C39)
    }

    func isCreateButtonEnable() -> Bool {
        return validatePassword() != .empty
    }

    func isInvalidLabelHidden() -> Bool {
        return validatePassword() != .invalid
    }

    func savePassword() -> Bool {
        if validatePassword() == .valid {
            self.settingManager.savePassword(password: self.enterPassword)
            return true
        }

        return false
    }

    mutating func updateInvalidLabelContent(contentValue: String) {
        self.invalidContent = contentValue
    }

    func invalidLabelContent() -> String {
        return self.invalidContent
    }
}

//
//  ChangePasswordViewModel.swift
//  Zip
//
//  Created by đào sơn on 01/09/2022.
//

import Foundation
import UIKit

private struct Const {
    static let defaultYourPassword = ""
    static let defaultNewPassword = ""
    static let defaultConfirmPassword = ""
}

enum ChangePasswordValidatedResult {
    case empty, invalid, valid, wrong
}
struct ChangePasswordViewModel {
    var yourPassword: String
    var newPassword: String
    var confirmPassword: String
    var invalidContent = "Invalid password"
    var settingManager = SettingManager()

    func validatePassword() -> ChangePasswordValidatedResult {
        if yourPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty {
            return .empty
        } else if newPassword != confirmPassword {
            return .invalid
        } else if settingManager.currentPassword() != yourPassword {
            return .wrong
        } else {
            return .valid
        }
    }

    init(yourPassword: String = Const.defaultYourPassword, newPassword: String = Const.defaultNewPassword, confirmPassword: String = Const.defaultConfirmPassword) {
        self.yourPassword = yourPassword
        self.newPassword = newPassword
        self.confirmPassword = confirmPassword
    }

    mutating func updatePassword(yourPassword: String, newPassword: String, confirmPassword: String) {
        self.yourPassword = yourPassword
        self.newPassword = newPassword
        self.confirmPassword = confirmPassword
    }

    func getUpdateButtonColor() -> UIColor? {
        let checkPasswordResult = validatePassword()
        return checkPasswordResult == .empty || checkPasswordResult == .invalid ? UIColor(rgb: 0xE0E0E0) : UIColor(rgb: 0xFF6C39)
    }

    func isUpdateButtonEnable() -> Bool {
        let checkPasswordResult = validatePassword()
        return checkPasswordResult != .empty && checkPasswordResult != .invalid
    }

    func isInvalidLabelHidden() -> Bool {
        let checkPasswordResult = validatePassword()
        return checkPasswordResult != .invalid && checkPasswordResult != .wrong
    }

    mutating func updateInvalidLabelContent(contentValue: String) {
        self.invalidContent = contentValue
    }

    func invalidLabelContent() -> String {
        return self.invalidContent
    }

    func savePassword() -> Bool {
        if validatePassword() == .valid {
            self.settingManager.savePassword(password: self.newPassword)
            return true
        }

        return false
    }

    mutating func updateInvalidLabelContent(isUpdateButtonClicked: Bool) {
        let checkPasswordResult = self.validatePassword()
        if !isUpdateButtonClicked {
            if checkPasswordResult == .wrong {
                self.invalidContent = ""
            } else {
                self.invalidContent = "Invalid password"
            }
        } else {
            if checkPasswordResult != .valid {
                self.invalidContent = "Please check your password"
            }
        }
    }
}

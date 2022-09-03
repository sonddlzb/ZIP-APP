//
//  InputPasswordViewModel.swift
//  Zip
//
//

import UIKit

struct InputPasswordViewModel {
    var password: String
    var purpose: InputPasswordPurpose
    var isIncorrectPassword: Bool

    init(password: String, purpose: InputPasswordPurpose) {
        self.password = password
        self.purpose = purpose
        self.isIncorrectPassword = false
    }

    func placeholder() -> String {
        return isIncorrectPassword ? "Incorrect password" : "Enter password for \(purpose.text()) file."
    }

    func okButtonTextColor() -> UIColor {
        return password.isEmpty ? UIColor(rgb: 0xCACACA) : UIColor(rgb: 0x575FCC)
    }

    func canOKButtonInteract() -> Bool {
        return !password.isEmpty
    }
}

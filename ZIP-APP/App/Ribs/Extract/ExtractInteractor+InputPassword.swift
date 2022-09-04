//
//  ExtractInteractor+InputPassword.swift
//  Zip
//
//

import Foundation

extension ExtractInteractor: InputPasswordListener {
    func inputPasswordDidSubmit(password: String) {
        self.router?.dismissInputPassword()
        self.password = password
        self.handleExtracting()
    }

    func inputPasswordWantToDismiss() {
        self.router?.dismissInputPassword()
    }

    func inputPasswordWantToSubmitPassword(password: String) -> Bool {
        return self.isPasswordZipCorrected(password: password)
    }
}

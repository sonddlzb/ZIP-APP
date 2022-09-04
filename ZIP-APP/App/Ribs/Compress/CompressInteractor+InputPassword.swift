//
//  CompressInteractor+InputPassword.swift
//  Zip
//
//

import Foundation

extension CompressInteractor: InputPasswordListener {
    func inputPasswordWantToDismiss() {
        self.router?.dismissInputPassword()
        listener?.compressWantToDismiss()
    }

    func inputPasswordWantToSubmitPassword(password: String) -> Bool {
        return true
    }

    func inputPasswordDidSubmit(password: String) {
        self.router?.dismissInputPassword()
        self.handleCompress(password: password)
    }
}

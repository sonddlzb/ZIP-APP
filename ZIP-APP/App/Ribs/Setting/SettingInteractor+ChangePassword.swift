//
//  SettingInteractor+ChangePassword.swift
//  Zip
//
//  Created by đào sơn on 01/09/2022.
//

import Foundation

extension SettingInteractor: ChangePasswordListener {
    func changePasswordWantToDismiss() {
        router?.dismissChangePassword()
    }
}

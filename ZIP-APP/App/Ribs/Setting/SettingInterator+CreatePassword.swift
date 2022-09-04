//
//  SettingInterator+CreatePassword.swift
//  Zip
//
//  Created by đào sơn on 30/08/2022.
//

import Foundation

extension SettingInteractor: CreatePasswordListener {
    func createPasswordWantToDismiss() {
        router?.dismissCreatePassword()
        self.presenter.bind(viewModel: self.settingViewModel)
    }
}

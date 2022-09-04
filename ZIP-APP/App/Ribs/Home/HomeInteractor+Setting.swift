//
//  HomeInteractor+Setting.swift
//  Zip
//
//  Created by đào sơn on 30/8/2022.
//

import Foundation

extension HomeInteractor: SettingListener {
    func settingWantToDismiss() {
        self.router?.dismissSetting()
    }
}

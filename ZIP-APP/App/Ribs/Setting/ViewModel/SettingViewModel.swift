//
//  SettingViewModel.swift
//  Zip
//
//  Created by đào sơn on 31/08/2022.
//

import Foundation
import UIKit

struct SettingViewModel {
    var settingManager = SettingManager()
    var storageSize: Double = 0.0
    var photoSize: Double = 0.0
    var audioSize: Double = 0.0

    mutating func changeDefaultPhotoSize(photoSize: DefaultPhotoSize) {
        self.settingManager.saveDefaultPhotoSize(defaultPhotoSize: photoSize)
    }

    func defaultPhotoSizeImage() -> (originalImage: UIImage?, mediumImage: UIImage?, smallImage: UIImage?) {
        let checkedImage = UIImage(named: "icon-radio-checked")
        let uncheckedImage = UIImage(named: "icon-radio-unchecked")
        let defaultPhotoSize = self.settingManager.currentDefaultPhotoSize()
        switch defaultPhotoSize {
        case .original: return (originalImage: checkedImage, mediumImage: uncheckedImage, smallImage: uncheckedImage)
        case .medium: return (originalImage: uncheckedImage, mediumImage: checkedImage, smallImage: uncheckedImage)
        case .small: return (originalImage: uncheckedImage, mediumImage: uncheckedImage, smallImage: checkedImage)
        }
    }

    func isPasswordSwitchEnable() -> Bool {
        return settingManager.hasPassword()
    }

    func deleteCurrentPassword() {
        guard settingManager.hasPassword() else {
            return
        }

        settingManager.deleteCurrentPassword()
    }

    func totalStorageSizeValue() -> String {
        return self.storageSize.exchangeDataSize()
    }

    func totalPhotoSizeValue() -> String {
        return self.photoSize.exchangeDataSize()
    }

    func totalAudioSizeValue() -> String {
        return self.audioSize.exchangeDataSize()
    }

    func defaultPhotoSizeColor() -> (originalColor: UIColor?, mediumColor: UIColor?, smallColor: UIColor?) {
        let checkedColor = UIColor(rgb: 0x5F5FCC)
        let uncheckedColor = UIColor(rgb: 0x283244)
        let defaultPhotoSize = self.settingManager.currentDefaultPhotoSize()
        switch defaultPhotoSize {
        case .original: return (originalColor: checkedColor, mediumColor: uncheckedColor, smallColor: uncheckedColor)
        case .medium: return (originalColor: uncheckedColor, mediumColor: checkedColor, smallColor: uncheckedColor)
        case .small: return (originalColor: uncheckedColor, mediumColor: uncheckedColor, smallColor: checkedColor)
        }
    }
}

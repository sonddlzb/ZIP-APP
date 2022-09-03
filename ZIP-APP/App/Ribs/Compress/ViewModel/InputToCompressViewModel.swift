//
//  InputToCompressViewModel.swift
//  Zip
//
//

import UIKit

struct InputToCompressViewModel {
    var isUsePassword: Bool
    var isReduceFile: Bool
    var name: String

    func isOkActionEnabled() -> Bool {
        return !name.isEmpty
    }

    func actionTextColor() -> UIColor {
        return name.isEmpty ? UIColor(rgb: 0xCACACA) : UIColor(rgb: 0x575FCC)
    }
}

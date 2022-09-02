//
//  OptionItemViewModel.swift
//  Zip
//
//

import UIKit

struct OptionItemViewModel {
    var actionType: OptionActionType
    var isHorizontal: Bool

    func image() -> UIImage {
        return actionType.image()
    }

    func description() -> String {
        return actionType.description()
    }
}

//
//  OptionActionType.swift
//  Zip
//
//

import UIKit
import DifferenceKit

enum OptionActionType: Int {
    case rename, share, extract, compress, delete, move, more

    var rawValue: Int {
        switch self {
        case .rename:
            return 1
        case .share:
            return 1 << 1
        case .extract:
            return 1 << 2
        case .compress:
            return 1 << 3
        case .delete:
            return 1 << 4
        case .move:
            return 1 << 5
        case .more:
            return 1 << 6
        }
    }

    func image() -> UIImage {
        switch self {
        case .rename:
            return UIImage(named: "ic_rename")!
        case .share:
            return UIImage(named: "ic_share")!
        case .extract:
            return UIImage(named: "ic_extract")!
        case .compress:
            return UIImage(named: "ic_compress")!
        case .delete:
            return UIImage(named: "ic_delete")!
        case .move:
            return UIImage(named: "ic_move")!
        case .more:
            return UIImage(named: "ic_more")!
        }
    }

    func description() -> String {
        switch self {
        case .rename:
            return "Rename"
        case .share:
            return "Share"
        case .extract:
            return "Extract"
        case .compress:
            return "Compress"
        case .delete:
            return "Delete"
        case .move:
            return "Move to"
        case .more:
            return "More"
        }
    }

    func priority() -> Int {
        switch self {
        case .rename, .share, .delete:
            return 1
        default:
            return 0
        }
    }
}

extension OptionActionType: Differentiable, Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawValue)
    }

    static func == (lhs: OptionActionType, rhs: OptionActionType) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

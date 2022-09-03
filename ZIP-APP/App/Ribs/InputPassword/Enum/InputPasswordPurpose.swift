//
//  InputPasswordPurpose.swift
//  Zip
//
//

import Foundation

enum InputPasswordPurpose {
    case extract
    case compress

    func text() -> String {
        switch self {
        case .extract:
            return "ecrypted"
        case .compress:
            return "decrypted"
        }
    }
}

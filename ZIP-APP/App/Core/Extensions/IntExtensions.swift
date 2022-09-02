//
//  IntExtensions.swift
//
//

import Foundation

private struct Const {
    static let pow3: Int = 1000
    static let pow6: Int = 1000000
    static let pow9: Int = 1000000000
}

public extension Int {
    func timeString() -> String {
        let minute = self / 60 % 60
        let second = self % 60

        // return formated string
        return String(format: "%02d:%02d", minute, second)
    }

    func shortDescription() -> String {
        if self < Const.pow3 {
            return "\(self)"
        }

        if self < Const.pow6 {
            return String(format: "%fk", Double(self * 10 / Const.pow3) / 10)
        }

        if self < Const.pow9 {
            return String(format: "%fM", Double(self * 10 / Const.pow6) / 10)
        }

        return String(format: "%fB", Double(self * 10 / Const.pow9) / 10)
    }
}

extension UInt64 {
    func memoryCapabilityDescription() -> String {
        if self < Const.pow3 {
            return "\(self) B"
        }

        if self < Const.pow6 {
            return String(format: "%d KB", self / UInt64(Const.pow3))
        }

        if self < Const.pow9 {
            return String(format: "%0.1f MB", Double(self) / Double(Const.pow6))
        }

        return String(format: "%0.1f GB", Double(self) / Double(Const.pow6))
    }
}

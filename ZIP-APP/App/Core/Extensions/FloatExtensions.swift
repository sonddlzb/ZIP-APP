//
//  FloatExtensions.swift
//
//

import Foundation

public extension Float {
    func ceil() -> Float {
        return ceilf(self)
    }

    func prettyString() -> String {
        if self == Float(Int(self)) {
            return "\(Int(self))"
        } else {
            return "\(self)"
        }
    }

    func prettyString(numberDigit: Int) -> String {
        let rounded = self.round(digit: numberDigit)
        if rounded == Float(Int(rounded)) {
            return "\(Int(rounded))"
        } else {
            let format = "%.0\(numberDigit)f"
            return String.init(format: format, rounded)
        }
    }

    func round(digit: Int) -> Float {
        let multipler = powf(10, Float(digit))

        return (self * multipler).rounded() / multipler
    }
}

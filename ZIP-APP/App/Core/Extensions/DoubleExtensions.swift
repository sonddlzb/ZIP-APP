//
//  DoubleExtensions.swift
//  KiteVid
//
//

import Foundation

public extension Double {
    func round(digit: Int) -> Double {
        let multipler = pow(10, Double(digit))

        return (self * multipler).rounded() / multipler
    }

    func exchangeDataSize() -> String {
        if self < pow(10, 3) {
            return String(format: "%.2f", self) + "B"
        } else if self < pow(10, 6) {
            return String(format: "%.2f", self/pow(10, 3)) + "K"
        } else if self < pow(10, 9) {
            return String(format: "%.2f", self/pow(10, 6)) + "M"
        } else {
            return String(format: "%.2f", self/pow(10, 9)) + "G"
        }
    }
}

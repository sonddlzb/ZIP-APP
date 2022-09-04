//
//  DefaultPhotoSize.swift
//  Zip
//
//

import Foundation

enum DefaultPhotoSize: Int {
    case original = 0
    case medium = 1
    case small = 2

    func compressionQuality() -> Double {
        switch self {
        case .original:
            return 0.9
        case .medium:
            return 0.6
        case .small:
            return 0.3
        }
    }
}

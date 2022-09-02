//
//  DeviceExtensions.swift
//
//

import Foundation
import UIKit

public extension UIDevice {
    class var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}

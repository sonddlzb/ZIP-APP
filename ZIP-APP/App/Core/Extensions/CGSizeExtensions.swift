//
//  CGSizeExtensions.swift
//  KiteVid
//
//

import Foundation
import UIKit

public extension CGSize {
    func ratio() -> CGFloat {
        return self.width / self.height
    }
}

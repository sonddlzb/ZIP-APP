//
//  UIViewControllerExtensions.swift
//
//

import Foundation
import UIKit

public extension UIViewController {
    func topVC() -> UIViewController {
        if let navigation = self as? UINavigationController, !navigation.viewControllers.isEmpty {
            return navigation.topViewController!.topVC()
        }

        if let presentedVC = self.presentedViewController {
            return presentedVC.topVC()
        }

        return self
    }
}

//
//  UIWindow+Extensions.swift
//  Zip
//
//

import UIKit

extension UIWindow {
    func topViewController() -> UIViewController? {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }

        var navigation = window.rootViewController as? BaseNavigationController
        while let topNavigation = navigation?.presentedViewController as? BaseNavigationController {
            navigation = topNavigation
        }

        return navigation?.topViewController
    }
}

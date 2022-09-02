//
//  RootBuilder.swift
//
//
//

import Foundation
import UIKit

import RIBs
import TLLogging

public extension ViewControllable {
    func push(viewControllable: ViewControllable, animated: Bool = true) {
        guard let navigation = self.uiviewController.navigationController else {
            DCHECK(false)
            return
        }

        navigation.pushViewController(viewControllable.uiviewController, animated: animated)
    }

    func pushWithPresentAnimation(viewControllable: ViewControllable) {
        guard let navigation = self.uiviewController.navigationController else {
            DCHECK(false)
            return
        }

        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .moveIn
        transition.subtype = .fromTop
        transition.timingFunction = CAMediaTimingFunction(name: .easeOut)

        navigation.view.layer.add(transition, forKey: kCATransition)
        navigation.pushViewController(viewControllable.uiviewController, animated: false)
    }

    func present(viewControllable: ViewControllable, animated: Bool = true, completion: (() -> Void)? = nil) {
        let navigationController = BaseNavigationController(rootViewController: viewControllable.uiviewController)
        navigationController.modalPresentationStyle = viewControllable.uiviewController.modalPresentationStyle
        self.uiviewController.present(navigationController, animated: animated, completion: completion)
    }

    func popViewControllale(animated: Bool = true) {
        guard let navigation = self.uiviewController.navigationController else {
            DCHECK(false)
            return
        }

        navigation.popViewController(animated: animated)
    }

    func popTop(viewControllable: ViewControllable, animated: Bool = true) {
        guard let navigation = self.uiviewController.navigationController else {
            DCHECK(false)
            return
        }

        if navigation.topViewController == viewControllable.uiviewController {
            self.popViewControllale(animated: animated)
        }
    }

    func popToBefore(viewControllable: ViewControllable, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let navigation = self.uiviewController.navigationController else {
            DCHECK(false)
            return
        }

        if let index = navigation.viewControllers.firstIndex(of: viewControllable.uiviewController), index > 0 {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                CATransaction.flush()
                completion?()
            }

            navigation.popToViewController(navigation.viewControllers[index-1], animated: animated)
            CATransaction.commit()
        } else {
            completion?()
        }
    }

    func popToRoot(animated: Bool = true) {
        guard let navigation = self.uiviewController.navigationController else {
            DCHECK(false)
            return
        }

        navigation.popToRootViewController(animated: animated)
    }

    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        if let navigation = self.uiviewController.navigationController {
            navigation.dismiss(animated: animated, completion: completion)
        } else {
            self.uiviewController.dismiss(animated: animated, completion: completion)
        }
    }
}

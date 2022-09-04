//
//  SettingRouter.swift
//  Zip
//
//  Created by đào sơn on 31/08/2022.
//

import RIBs

protocol SettingInteractable: Interactable, CreatePasswordListener, ChangePasswordListener {
    var router: SettingRouting? { get set }
    var listener: SettingListener? { get set }
}

protocol SettingViewControllable: ViewControllable {
}

final class SettingRouter: ViewableRouter<SettingInteractable, SettingViewControllable> {

    var createPasswordBuilder: CreatePasswordBuildable
    var createPasswordRouter: CreatePasswordRouting?
    var changePasswordBuilder: ChangePasswordBuildable
    var changePasswordRouter: ChangePasswordRouting?

    init(interactor: SettingInteractable,
         viewController: SettingViewControllable,
         createPasswordBuilder: CreatePasswordBuildable,
         changePasswordBuilder: ChangePasswordBuildable) {
        self.createPasswordBuilder = createPasswordBuilder
        self.changePasswordBuilder = changePasswordBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: SettingRouting
extension SettingRouter: SettingRouting {
    func dismissCreatePassword() {
        guard let router = createPasswordRouter else {
            return
        }

        self.viewControllable.dismiss()
        detachChild(router)
        self.createPasswordRouter = nil
    }

    func routeToCreatePassword() {
        let createPasswordRouter = createPasswordBuilder.build(withListener: interactor)
        self.viewController.present(viewControllable: createPasswordRouter.viewControllable)
        attachChild(createPasswordRouter)
        self.createPasswordRouter = createPasswordRouter
    }

    func routeToChangePassword() {
        let changePasswordRouter = changePasswordBuilder.build(withListener: interactor)
        self.viewController.present(viewControllable: changePasswordRouter.viewControllable)
        attachChild(changePasswordRouter)
        self.changePasswordRouter = changePasswordRouter
    }

    func dismissChangePassword() {
        guard let router = changePasswordRouter else {
            return
        }

        self.viewControllable.dismiss()
        detachChild(router)
        self.changePasswordRouter = nil
    }
}

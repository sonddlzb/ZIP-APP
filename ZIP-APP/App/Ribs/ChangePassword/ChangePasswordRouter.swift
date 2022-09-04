//
//  ChangePasswordRouter.swift
//  Zip
//
//  Created by đào sơn on 01/09/2022.
//

import RIBs

protocol ChangePasswordInteractable: Interactable {
    var router: ChangePasswordRouting? { get set }
    var listener: ChangePasswordListener? { get set }
}

protocol ChangePasswordViewControllable: ViewControllable {
}

final class ChangePasswordRouter: ViewableRouter<ChangePasswordInteractable, ChangePasswordViewControllable>, ChangePasswordRouting {
    
    override init(interactor: ChangePasswordInteractable, viewController: ChangePasswordViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

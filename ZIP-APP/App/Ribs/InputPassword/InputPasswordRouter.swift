//
//  InputPasswordRouter.swift
//  Zip
//
//

import RIBs

protocol InputPasswordInteractable: Interactable {
    var router: InputPasswordRouting? { get set }
    var listener: InputPasswordListener? { get set }
}

protocol InputPasswordViewControllable: ViewControllable {
}

final class InputPasswordRouter: ViewableRouter<InputPasswordInteractable, InputPasswordViewControllable>, InputPasswordRouting {
    
    override init(interactor: InputPasswordInteractable, viewController: InputPasswordViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

//
//  InputToCompressRouter.swift
//  Zip
//
//

import RIBs

protocol InputToCompressInteractable: Interactable {
    var router: InputToCompressRouting? { get set }
    var listener: InputToCompressListener? { get set }
}

protocol InputToCompressViewControllable: ViewControllable {
}

final class InputToCompressRouter: ViewableRouter<InputToCompressInteractable, InputToCompressViewControllable>, InputToCompressRouting {

    override init(interactor: InputToCompressInteractable, viewController: InputToCompressViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

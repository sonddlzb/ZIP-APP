//
//  OpenZipRouter.swift
//  Zip
//
//

import RIBs

protocol OpenZipInteractable: Interactable {
    var router: OpenZipRouting? { get set }
    var listener: OpenZipListener? { get set }
}

protocol OpenZipViewControllable: ViewControllable {
}

final class OpenZipRouter: ViewableRouter<OpenZipInteractable, OpenZipViewControllable>, OpenZipRouting {
    
    override init(interactor: OpenZipInteractable, viewController: OpenZipViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

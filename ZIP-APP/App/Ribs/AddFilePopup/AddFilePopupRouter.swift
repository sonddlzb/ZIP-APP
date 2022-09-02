//
//  AddFilePopupRouter.swift
//  Zip
//
//

import RIBs

protocol AddFilePopupInteractable: Interactable {
    var router: AddFilePopupRouting? { get set }
    var listener: AddFilePopupListener? { get set }
}

protocol AddFilePopupViewControllable: ViewControllable {
}

final class AddFilePopupRouter: ViewableRouter<AddFilePopupInteractable, AddFilePopupViewControllable>, AddFilePopupRouting {
    
    override init(interactor: AddFilePopupInteractable, viewController: AddFilePopupViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

//
//  RenameItemRouter.swift
//  Zip
//
//

import RIBs

protocol RenameItemInteractable: Interactable {
    var router: RenameItemRouting? { get set }
    var listener: RenameItemListener? { get set }
}

protocol RenameItemViewControllable: ViewControllable {
}

final class RenameItemRouter: ViewableRouter<RenameItemInteractable, RenameItemViewControllable>, RenameItemRouting {
    
    override init(interactor: RenameItemInteractable, viewController: RenameItemViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

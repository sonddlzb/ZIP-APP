//
//  CreatePasswordRouter.swift
//  Zip
//
//  Created by đào sơn on 31/08/2022.
//

import RIBs

protocol CreatePasswordInteractable: Interactable {
    var router: CreatePasswordRouting? { get set }
    var listener: CreatePasswordListener? { get set }
}

protocol CreatePasswordViewControllable: ViewControllable {
}

final class CreatePasswordRouter: ViewableRouter<CreatePasswordInteractable, CreatePasswordViewControllable>, CreatePasswordRouting {
    
    override init(interactor: CreatePasswordInteractable, viewController: CreatePasswordViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

//
//  PreviewVideoRouter.swift
//  Zip
//
//  Created by đào sơn on 03/09/2022.
//

import RIBs

protocol PreviewVideoInteractable: Interactable {
    var router: PreviewVideoRouting? { get set }
    var listener: PreviewVideoListener? { get set }
}

protocol PreviewVideoViewControllable: ViewControllable {
}

final class PreviewVideoRouter: ViewableRouter<PreviewVideoInteractable, PreviewVideoViewControllable>, PreviewVideoRouting {

    override init(interactor: PreviewVideoInteractable, viewController: PreviewVideoViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

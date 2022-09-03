//
//  PreviewImageRouter.swift
//  Zip
//
//  Created by đào sơn on 03/09/2022.
//

import RIBs

protocol PreviewImageInteractable: Interactable {
    var router: PreviewImageRouting? { get set }
    var listener: PreviewImageListener? { get set }
}

protocol PreviewImageViewControllable: ViewControllable {
}

final class PreviewImageRouter: ViewableRouter<PreviewImageInteractable, PreviewImageViewControllable>, PreviewImageRouting {
    
    override init(interactor: PreviewImageInteractable, viewController: PreviewImageViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

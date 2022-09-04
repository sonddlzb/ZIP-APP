//
//  ExtractLoadingRouter.swift
//  Zip
//
//

import RIBs

protocol ExtractLoadingInteractable: Interactable {
    var router: ExtractLoadingRouting? { get set }
    var listener: ExtractLoadingListener? { get set }
}

protocol ExtractLoadingViewControllable: ViewControllable {
}

final class ExtractLoadingRouter: ViewableRouter<ExtractLoadingInteractable, ExtractLoadingViewControllable>, ExtractLoadingRouting {
    
    override init(interactor: ExtractLoadingInteractable, viewController: ExtractLoadingViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

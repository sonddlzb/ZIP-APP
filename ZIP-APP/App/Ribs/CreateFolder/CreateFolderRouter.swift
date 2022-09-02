//
//  CreateFolderRouter.swift
//  Zip
//
//

import RIBs

protocol CreateFolderInteractable: Interactable {
    var router: CreateFolderRouting? { get set }
    var listener: CreateFolderListener? { get set }
}

protocol CreateFolderViewControllable: ViewControllable {
}

final class CreateFolderRouter: ViewableRouter<CreateFolderInteractable, CreateFolderViewControllable>, CreateFolderRouting {
    
    override init(interactor: CreateFolderInteractable, viewController: CreateFolderViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

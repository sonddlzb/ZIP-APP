//
//  CompressLoadingRouter.swift
//  Zip
//
//

import RIBs

protocol CompressLoadingInteractable: Interactable {
    var router: CompressLoadingRouting? { get set }
    var listener: CompressLoadingListener? { get set }
}

protocol CompressLoadingViewControllable: ViewControllable {
}

final class CompressLoadingRouter: ViewableRouter<CompressLoadingInteractable, CompressLoadingViewControllable> {
    
    override init(interactor: CompressLoadingInteractable, viewController: CompressLoadingViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - CompressLoadingRouting
extension CompressLoadingRouter: CompressLoadingRouting {
    func removeViewControllerFromNavigation() {
        self.viewControllable.uiviewController.dismiss(animated: true)
    }
}

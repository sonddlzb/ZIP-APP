//
//  SelectAudioRouter.swift
//  Zip
//
//

import RIBs

protocol SelectAudioInteractable: Interactable {
    var router: SelectAudioRouting? { get set }
    var listener: SelectAudioListener? { get set }
}

protocol SelectAudioViewControllable: ViewControllable {
}

final class SelectAudioRouter: ViewableRouter<SelectAudioInteractable, SelectAudioViewControllable> {
    
    override init(interactor: SelectAudioInteractable, viewController: SelectAudioViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - SelectAudioRouting
extension SelectAudioRouter: SelectAudioRouting {
    func removeViewControllerFromNavigation() {
        let navigation = self.viewController.uiviewController.navigationController
        navigation?.viewControllers.removeObject(self.viewController.uiviewController)
    }
}

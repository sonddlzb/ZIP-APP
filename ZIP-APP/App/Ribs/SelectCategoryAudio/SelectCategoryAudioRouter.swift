//
//  SelectCategoryAudioRouter.swift
//  Zip
//
//

import RIBs
import MediaPlayer

protocol SelectCategoryAudioInteractable: Interactable, SelectAudioListener {
    var router: SelectCategoryAudioRouting? { get set }
    var listener: SelectCategoryAudioListener? { get set }
}

protocol SelectCategoryAudioViewControllable: ViewControllable {
}

final class SelectCategoryAudioRouter: ViewableRouter<SelectCategoryAudioInteractable, SelectCategoryAudioViewControllable> {
    var selectAudioBuilder: SelectAudioBuildable
    var selectAudioRouter: SelectAudioRouting?

    init(interactor: SelectCategoryAudioInteractable,
         viewController: SelectCategoryAudioViewControllable,
         selectAudioBuilder: SelectAudioBuildable) {
        self.selectAudioBuilder = selectAudioBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - SelectCategoryAudioRouting
extension SelectCategoryAudioRouter: SelectCategoryAudioRouting {
    func removeViewControllerFromNavigation() {
        let navigation = self.viewController.uiviewController.navigationController
        navigation?.viewControllers.removeObject(self.viewController.uiviewController)
    }

    func routeToSelectAudio(category: MPMediaItemCollection) {
        let router = self.selectAudioBuilder.build(withListener: self.interactor, category: category)
        self.viewController.push(viewControllable: router.viewControllable)
        attachChild(router)
        self.selectAudioRouter = router
    }

    func dismissSelectAudio() {
        guard let router = self.selectAudioRouter else {
            return
        }

        self.viewController.popToBefore(viewControllable: router.viewControllable)
        detachChild(router)
        self.selectAudioRouter = router
    }
}

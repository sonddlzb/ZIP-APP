//
//  ExtractRouter.swift
//  Zip
//
//

import RIBs

protocol ExtractInteractable: Interactable, InputPasswordListener, ExtractLoadingListener {
    var router: ExtractRouting? { get set }
    var listener: ExtractListener? { get set }
}

protocol ExtractViewControllable: ViewControllable {
    func showAskBeforeExtractingDialog(action: (() -> Void)?, cancelAction: (() -> Void)?)
}

final class ExtractRouter: Router<ExtractInteractable> {
    var viewController: ExtractViewControllable

    var inputPasswordBuilder: InputPasswordBuildable
    var inputPasswordRouter: InputPasswordRouting?

    var extractLoadingBuilder: ExtractLoadingBuildable
    var extractLoadingRouter: ExtractLoadingRouting?

    init(interactor: ExtractInteractable,
         viewController: ExtractViewControllable,
         inputPasswordBuilder: InputPasswordBuildable,
         extractLoadingBuilder: ExtractLoadingBuildable) {
        self.viewController = viewController
        self.inputPasswordBuilder = inputPasswordBuilder
        self.extractLoadingBuilder = extractLoadingBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }
}

// MARK: - ExtractRouting
extension ExtractRouter: ExtractRouting {
    func routeToInputPassword() {
        let router = self.inputPasswordBuilder.build(withListener: self.interactor, purpose: .extract)
        self.viewController.present(viewControllable: router.viewControllable)
        attachChild(router)
        self.inputPasswordRouter = router
    }

    func dismissInputPassword() {
        guard let router = self.inputPasswordRouter else {
            return
        }

        router.viewControllable.dismiss()
        detachChild(router)
        self.inputPasswordRouter = nil
    }

    func routeToExtractLoading() {
        let router = self.extractLoadingBuilder.build(withListener: self.interactor)
        self.viewController.present(viewControllable: router.viewControllable)
        attachChild(router)
        self.extractLoadingRouter = router
    }

    func dismissExtractLoading() {
        guard let router = self.extractLoadingRouter else {
            return
        }

        router.viewControllable.dismiss()
        detachChild(router)
        self.extractLoadingRouter = nil
    }
}

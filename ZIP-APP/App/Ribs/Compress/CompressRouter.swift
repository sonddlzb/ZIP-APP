//
//  CompressRouter.swift
//  Zip
//
//

import RIBs

protocol CompressInteractable: Interactable, InputToCompressListener, CompressLoadingListener, InputPasswordListener {
    var router: CompressRouting? { get set }
    var listener: CompressListener? { get set }
}

protocol CompressViewControllable: ViewControllable {
    func showAlert(title: String, message: String, action: (() -> Void)?, cancelAction: (() -> Void)?)
}

final class CompressRouter: Router<CompressInteractable> {
    private let viewController: CompressViewControllable

    var inputToCompressBuilder: InputToCompressBuildable
    var inputToCompressRouter: InputToCompressRouting?

    var compressLoadingBuilder: CompressLoadingBuildable
    var compressLoadingRouter: CompressLoadingRouting?

    var inputPasswordBuilder: InputPasswordBuildable
    var inputPasswordRouter: InputPasswordRouting?

    init(interactor: CompressInteractable,
         viewController: CompressViewControllable,
         inputToCompressBuilder: InputToCompressBuildable,
         compressLoadingBuilder: CompressLoadingBuildable,
         inputPasswordBuilder: InputPasswordBuildable) {
        self.viewController = viewController
        self.inputToCompressBuilder = inputToCompressBuilder
        self.compressLoadingBuilder = compressLoadingBuilder
        self.inputPasswordBuilder = inputPasswordBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }
}

// MARK: - CompressRouting
extension CompressRouter: CompressRouting {
    func routeToInputToCompress() {
        let router = inputToCompressBuilder.build(withListener: self.interactor)
        self.viewController.present(viewControllable: router.viewControllable)
        attachChild(router)
        self.inputToCompressRouter = router
    }

    func dismissInputToCompress() {
        guard let router = self.inputToCompressRouter else {
            return
        }

        router.viewControllable.dismiss()
        detachChild(router)
        self.inputToCompressRouter = nil
    }

    func routeToLoading() {
        let router = compressLoadingBuilder.build(withListener: self.interactor)
        self.viewController.present(viewControllable: router.viewControllable)
        attachChild(router)
        self.compressLoadingRouter = router
    }

    func dismissLoading() {
        guard let router = self.compressLoadingRouter else {
            return
        }

        router.viewControllable.dismiss()
        detachChild(router)
        self.compressLoadingRouter = nil
    }

    func routeToInputPassword() {
        let router = inputPasswordBuilder.build(withListener: self.interactor, purpose: .compress)
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
}

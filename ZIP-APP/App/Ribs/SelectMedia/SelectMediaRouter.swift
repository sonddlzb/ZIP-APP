//
//  SelectMediaRouter.swift
//  Zip
//
//  Created by đào sơn on 03/09/2022.
//

import RIBs
import Photos
protocol SelectMediaInteractable: Interactable, PreviewImageListener, PreviewVideoListener {
    var router: SelectMediaRouting? { get set }
    var listener: SelectMediaListener? { get set }
}

protocol SelectMediaViewControllable: ViewControllable {
}

final class SelectMediaRouter: ViewableRouter<SelectMediaInteractable, SelectMediaViewControllable> {
    var previewImageBuilder: PreviewImageBuildable
    var previewImageRouter: PreviewImageRouting?
    var previewVideoBuilder: PreviewVideoBuildable
    var previewVideoRouter: PreviewVideoRouting?

    init(interactor: SelectMediaInteractable,
         viewController: SelectMediaViewControllable,
         previewImageBuilder: PreviewImageBuildable,
         previewVideoBuilder: PreviewVideoBuildable) {
        self.previewImageBuilder = previewImageBuilder
        self.previewVideoBuilder = previewVideoBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: SelectMediaRouting
extension SelectMediaRouter: SelectMediaRouting {
    func removeViewControllerFromNavigation() {
        if let navigation = self.viewController.uiviewController.navigationController {
            navigation.viewControllers.removeObject(self.viewController.uiviewController)
        }
    }

    func routeToPreviewImage(asset: PHAsset) {
        guard self.previewImageRouter == nil else {
            return
        }

        let previewImageRouter = previewImageBuilder.build(withListener: self.interactor, asset: asset)
        self.viewControllable.present(viewControllable: previewImageRouter.viewControllable)
        attachChild(previewImageRouter)
        self.previewImageRouter = previewImageRouter
    }

    func dismissPreviewImage() {
        guard let router = previewImageRouter else {
            return
        }

        self.viewControllable.dismiss()
        detachChild(router)
        self.previewImageRouter = nil
    }

    func routeToPreviewVideo(asset: PHAsset) {
        guard self.previewVideoRouter == nil else {
            return
        }

        let previewVideoRouter = previewVideoBuilder.build(withListener: self.interactor, asset: asset)
        self.viewControllable.present(viewControllable: previewVideoRouter.viewControllable)
        attachChild(previewVideoRouter)
        self.previewVideoRouter = previewVideoRouter
    }

    func dismissPreviewVideo() {
        guard let router = previewVideoRouter else {
            return
        }

        self.viewControllable.dismiss()
        detachChild(router)
        self.previewVideoRouter = nil
    }
}

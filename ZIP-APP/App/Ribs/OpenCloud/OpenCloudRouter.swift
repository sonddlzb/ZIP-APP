//
//  OpenCloudRouter.swift
//  Zip
//
//

import RIBs

protocol OpenCloudInteractable: Interactable, OpenCloudListener {
    var router: OpenCloudRouting? { get set }
    var listener: OpenCloudListener? { get set }
}

protocol OpenCloudViewControllable: ViewControllable {
}

final class OpenCloudRouter: ViewableRouter<OpenCloudInteractable, OpenCloudViewControllable> {
    var openCloudBuilder: OpenCloudBuildable
    var childOpenCloudRouter: OpenCloudRouting?

    init(interactor: OpenCloudInteractable,
         viewController: OpenCloudViewControllable,
         openCloudBuilder: OpenCloudBuildable) {
        self.openCloudBuilder = openCloudBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - OpenCloudRouting
extension OpenCloudRouter: OpenCloudRouting {
    func routeToOpenCloud(cloudItem: CloudItem, parentId: String?, cloudService: CloudService) {
        let router = self.openCloudBuilder.build(withListener: self.interactor, cloudItem: cloudItem, parentId: parentId, cloudService: cloudService)
        self.viewController.push(viewControllable: router.viewControllable)
        attachChild(router)
        self.childOpenCloudRouter = router
    }

    func dismissOpenCloud() {
        guard let router = self.childOpenCloudRouter else {
            return
        }

        self.viewControllable.popToBefore(viewControllable: router.viewControllable)
        detachChild(router)
        self.childOpenCloudRouter = nil
    }
}

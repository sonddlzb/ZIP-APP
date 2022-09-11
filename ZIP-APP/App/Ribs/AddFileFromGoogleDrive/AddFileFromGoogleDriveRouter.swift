//
//  AddFileFromGoogleDriveRouter.swift
//  Zip
//
//

import RIBs

protocol AddFileFromGoogleDriveInteractable: Interactable, OpenCloudListener {
    var router: AddFileFromGoogleDriveRouting? { get set }
    var listener: AddFileFromGoogleDriveListener? { get set }
}

protocol AddFileFromGoogleDriveViewControllable: ViewControllable {
}

final class AddFileFromGoogleDriveRouter: Router<AddFileFromGoogleDriveInteractable> {
    var viewController: AddFileFromGoogleDriveViewControllable

    var openCloudBuilder: OpenCloudBuildable
    var openCloudRouter: OpenCloudRouting?

    init(interactor: AddFileFromGoogleDriveInteractable,
         viewController: AddFileFromGoogleDriveViewControllable,
         openCloudBuilder: OpenCloudBuildable) {
        self.viewController = viewController
        self.openCloudBuilder = openCloudBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }
}

// MARK: - AddFileFromGoogleDriveRouting
extension AddFileFromGoogleDriveRouter: AddFileFromGoogleDriveRouting {
    func routeToOpenCloud(cloudItem: CloudItem, parentId: String?) {
        let router = self.openCloudBuilder.build(withListener: self.interactor, cloudItem: cloudItem, parentId: parentId, cloudService: GoogleDriveService.shared)
        self.viewController.push(viewControllable: router.viewControllable)
        attachChild(router)
        self.openCloudRouter = router
    }

    func dismissOpenCloud() {
        guard let router = self.openCloudRouter else {
            return
        }

        self.viewController.popToBefore(viewControllable: router.viewControllable)
        detachChild(router)
        self.openCloudRouter = nil
    }
}

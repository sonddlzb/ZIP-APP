//
//  RootRouter.swift
//  Zip
//
//

import RIBs

protocol RootInteractable: Interactable, HomeListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
}

final class RootRouter: ViewableRouter<RootInteractable, RootViewControllable> {
    var window: UIWindow

    var homeBuilder: HomeBuildable
    var homeRouter: HomeRouting?

    init(interactor: RootInteractable,
         viewController: RootViewControllable,
         window: UIWindow,
         homeBuilder: HomeBuildable) {
        self.window = window
        self.homeBuilder = homeBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - RootRouting
extension RootRouter: RootRouting {
    func routeToHome() {
        let router = homeBuilder.build(withListener: self.interactor)
        let navigationController = BaseNavigationController(rootViewController: router.viewControllable.uiviewController)
        window.rootViewController = navigationController
        attachChild(router)
        self.homeRouter = router
    }
}

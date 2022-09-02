//
//  RenameItemBuilder.swift
//  Zip
//
//

import RIBs

protocol RenameItemDependency: Dependency {

}

final class RenameItemComponent: Component<RenameItemDependency> {
}

// MARK: - Builder

protocol RenameItemBuildable: Buildable {
    func build(withListener listener: RenameItemListener, inputURL: URL) -> RenameItemRouting
}

final class RenameItemBuilder: Builder<RenameItemDependency>, RenameItemBuildable {

    override init(dependency: RenameItemDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RenameItemListener, inputURL: URL) -> RenameItemRouting {
        // let component = RenameItemComponent(dependency: dependency)
        let viewController = RenameItemViewController()
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve

        let interactor = RenameItemInteractor(presenter: viewController, inputURL: inputURL)
        interactor.listener = listener

        return RenameItemRouter(interactor: interactor, viewController: viewController)
    }
}

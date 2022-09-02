//
//  AddFilePopupBuilder.swift
//  Zip
//
//

import RIBs

protocol AddFilePopupDependency: Dependency {

}

final class AddFilePopupComponent: Component<AddFilePopupDependency> {
}

// MARK: - Builder

protocol AddFilePopupBuildable: Buildable {
    func build(withListener listener: AddFilePopupListener) -> AddFilePopupRouting
}

final class AddFilePopupBuilder: Builder<AddFilePopupDependency>, AddFilePopupBuildable {

    override init(dependency: AddFilePopupDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AddFilePopupListener) -> AddFilePopupRouting {
        // let component = AddFilePopupComponent(dependency: dependency)
        let viewController = AddFilePopupViewController()
        viewController.modalPresentationStyle = .overFullScreen

        let interactor = AddFilePopupInteractor(presenter: viewController)
        interactor.listener = listener

        return AddFilePopupRouter(interactor: interactor, viewController: viewController)
    }
}

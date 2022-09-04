//
//  ChangePasswordBuilder.swift
//  Zip
//
//  Created by đào sơn on 01/09/2022.
//

import RIBs

protocol ChangePasswordDependency: Dependency {

}

final class ChangePasswordComponent: Component<ChangePasswordDependency> {
}

// MARK: - Builder

protocol ChangePasswordBuildable: Buildable {
    func build(withListener listener: ChangePasswordListener) -> ChangePasswordRouting
}

final class ChangePasswordBuilder: Builder<ChangePasswordDependency>, ChangePasswordBuildable {

    override init(dependency: ChangePasswordDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ChangePasswordListener) -> ChangePasswordRouting {
        // let component = ChangePasswordComponent(dependency: dependency)
        let viewController = ChangePasswordViewController()
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .coverVertical
        let interactor = ChangePasswordInteractor(presenter: viewController)
        interactor.listener = listener
        return ChangePasswordRouter(interactor: interactor, viewController: viewController)
    }
}

//
//  CreatePasswordBuilder.swift
//  Zip
//
//  Created by đào sơn on 31/08/2022.
//

import RIBs

protocol CreatePasswordDependency: Dependency {

}

final class CreatePasswordComponent: Component<CreatePasswordDependency> {
}

// MARK: - Builder

protocol CreatePasswordBuildable: Buildable {
    func build(withListener listener: CreatePasswordListener) -> CreatePasswordRouting
}

final class CreatePasswordBuilder: Builder<CreatePasswordDependency>, CreatePasswordBuildable {

    override init(dependency: CreatePasswordDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CreatePasswordListener) -> CreatePasswordRouting {
        //let component = CreatePasswordComponent(dependency: dependency)
        let viewController = CreatePasswordViewController()
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .coverVertical
        let interactor = CreatePasswordInteractor(presenter: viewController)
        interactor.listener = listener
        return CreatePasswordRouter(interactor: interactor, viewController: viewController)
    }
}

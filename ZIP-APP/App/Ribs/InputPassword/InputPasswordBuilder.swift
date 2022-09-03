//
//  InputPasswordBuilder.swift
//  Zip
//
//

import RIBs

protocol InputPasswordDependency: Dependency {

}

final class InputPasswordComponent: Component<InputPasswordDependency> {
}

// MARK: - Builder

protocol InputPasswordBuildable: Buildable {
    func build(withListener listener: InputPasswordListener, purpose: InputPasswordPurpose) -> InputPasswordRouting
}

final class InputPasswordBuilder: Builder<InputPasswordDependency>, InputPasswordBuildable {

    override init(dependency: InputPasswordDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: InputPasswordListener, purpose: InputPasswordPurpose) -> InputPasswordRouting {
        // let component = InputPasswordComponent(dependency: dependency)
        let viewController = InputPasswordViewController()
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve

        let interactor = InputPasswordInteractor(presenter: viewController, purpose: purpose)
        interactor.listener = listener
        return InputPasswordRouter(interactor: interactor, viewController: viewController)
    }
}

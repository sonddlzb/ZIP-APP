//
//  InputToCompressBuilder.swift
//  Zip
//
//

import RIBs

protocol InputToCompressDependency: Dependency {

}

final class InputToCompressComponent: Component<InputToCompressDependency> {
}

// MARK: - Builder

protocol InputToCompressBuildable: Buildable {
    func build(withListener listener: InputToCompressListener) -> InputToCompressRouting
}

final class InputToCompressBuilder: Builder<InputToCompressDependency>, InputToCompressBuildable {

    override init(dependency: InputToCompressDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: InputToCompressListener) -> InputToCompressRouting {
        // let component = InputToCompressComponent(dependency: dependency)
        let viewController = InputToCompressViewController()
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve

        let interactor = InputToCompressInteractor(presenter: viewController)
        interactor.listener = listener

        return InputToCompressRouter(interactor: interactor, viewController: viewController)
    }
}

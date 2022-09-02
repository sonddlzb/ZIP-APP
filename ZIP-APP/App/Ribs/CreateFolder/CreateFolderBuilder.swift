//
//  CreateFolderBuilder.swift
//  Zip
//
//

import RIBs

protocol CreateFolderDependency: Dependency {

}

final class CreateFolderComponent: Component<CreateFolderDependency> {
}

// MARK: - Builder

protocol CreateFolderBuildable: Buildable {
    func build(withListener listener: CreateFolderListener, inputURL: URL) -> CreateFolderRouting
}

final class CreateFolderBuilder: Builder<CreateFolderDependency>, CreateFolderBuildable {

    override init(dependency: CreateFolderDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CreateFolderListener, inputURL: URL) -> CreateFolderRouting {
        // let component = CreateFolderComponent(dependency: dependency)
        let viewController = CreateFolderViewController()
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve

        let interactor = CreateFolderInteractor(presenter: viewController, inputURL: inputURL)
        interactor.listener = listener

        return CreateFolderRouter(interactor: interactor, viewController: viewController)
    }
}

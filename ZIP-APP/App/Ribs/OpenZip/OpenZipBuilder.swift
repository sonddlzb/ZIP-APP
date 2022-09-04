//
//  OpenZipBuilder.swift
//  Zip
//
//

import RIBs

protocol OpenZipDependency: Dependency {

}

final class OpenZipComponent: Component<OpenZipDependency> {
}

// MARK: - Builder

protocol OpenZipBuildable: Buildable {
    func build(withListener listener: OpenZipListener, zipURL: URL) -> OpenZipRouting
}

final class OpenZipBuilder: Builder<OpenZipDependency>, OpenZipBuildable {

    override init(dependency: OpenZipDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: OpenZipListener, zipURL: URL) -> OpenZipRouting {
        // let component = OpenZipComponent(dependency: dependency)
        let viewController = OpenZipViewController()
        let interactor = OpenZipInteractor(presenter: viewController, zipURL: zipURL)
        interactor.listener = listener
        return OpenZipRouter(interactor: interactor, viewController: viewController)
    }
}

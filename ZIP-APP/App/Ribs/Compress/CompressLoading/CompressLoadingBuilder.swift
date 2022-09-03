//
//  CompressLoadingBuilder.swift
//  Zip
//
//

import RIBs

protocol CompressLoadingDependency: Dependency {

}

final class CompressLoadingComponent: Component<CompressLoadingDependency> {
}

// MARK: - Builder

protocol CompressLoadingBuildable: Buildable {
    func build(withListener listener: CompressLoadingListener) -> CompressLoadingRouting
}

final class CompressLoadingBuilder: Builder<CompressLoadingDependency>, CompressLoadingBuildable {

    override init(dependency: CompressLoadingDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CompressLoadingListener) -> CompressLoadingRouting {
        // let component = CompressLoadingComponent(dependency: dependency)
        let viewController = CompressLoadingViewController()
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve

        let interactor = CompressLoadingInteractor(presenter: viewController)
        interactor.listener = listener
        return CompressLoadingRouter(interactor: interactor, viewController: viewController)
    }
}

//
//  ExtractLoadingBuilder.swift
//  Zip
//
//

import RIBs

protocol ExtractLoadingDependency: Dependency {

}

final class ExtractLoadingComponent: Component<ExtractLoadingDependency> {
}

// MARK: - Builder

protocol ExtractLoadingBuildable: Buildable {
    func build(withListener listener: ExtractLoadingListener) -> ExtractLoadingRouting
}

final class ExtractLoadingBuilder: Builder<ExtractLoadingDependency>, ExtractLoadingBuildable {

    override init(dependency: ExtractLoadingDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ExtractLoadingListener) -> ExtractLoadingRouting {
        // let component = ExtractLoadingComponent(dependency: dependency)
        let viewController = ExtractLoadingViewController()
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve

        let interactor = ExtractLoadingInteractor(presenter: viewController)
        interactor.listener = listener
        
        return ExtractLoadingRouter(interactor: interactor, viewController: viewController)
    }
}

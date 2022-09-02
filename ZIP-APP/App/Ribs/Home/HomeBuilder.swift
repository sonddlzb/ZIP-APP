//
//  HomeBuilder.swift
//  Zip
//
//

import RIBs

protocol HomeDependency: Dependency {

}

final class HomeComponent: Component<HomeDependency> {
    var viewController: HomeViewControllable
    init(dependency: HomeDependency, viewController: HomeViewControllable) {
        self.viewController = viewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol HomeBuildable: Buildable {
    func build(withListener listener: HomeListener) -> HomeRouting
}

final class HomeBuilder: Builder<HomeDependency>, HomeBuildable {

    override init(dependency: HomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: HomeListener) -> HomeRouting {
        let viewController = HomeViewController()
        let component = HomeComponent(dependency: dependency, viewController: viewController)

        let interactor = HomeInteractor(presenter: viewController)
        interactor.listener = listener

        let openFolderBuilder = DIContainer.resolve(OpenFolderBuildable.self, agrument: component)

        return HomeRouter(interactor: interactor,
                          viewController: viewController,
                            openFolderBuilder: openFolderBuilder)
    }
}

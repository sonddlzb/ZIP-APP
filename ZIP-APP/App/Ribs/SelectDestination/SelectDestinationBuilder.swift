//
//  SelectDestinationBuilder.swift
//  Zip
//
//

import RIBs

protocol SelectDestinationDependency: Dependency {

}

final class SelectDestinationComponent: Component<SelectDestinationDependency> {
}

// MARK: - Builder

protocol SelectDestinationBuildable: Buildable {
    func build(withListener listener: SelectDestinationListener, exceptedURLs: [URL]) -> SelectDestinationRouting
}

final class SelectDestinationBuilder: Builder<SelectDestinationDependency>, SelectDestinationBuildable {

    override init(dependency: SelectDestinationDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SelectDestinationListener, exceptedURLs: [URL]) -> SelectDestinationRouting {
        let component = SelectDestinationComponent(dependency: dependency)
        let viewController = SelectDestinationViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .coverVertical

        let interactor = SelectDestinationInteractor(presenter: viewController, exceptedURLs: exceptedURLs)
        interactor.listener = listener

        let folderDetailBuilder = DIContainer.resolve(FolderDetailBuildable.self, agrument: component)

        return SelectDestinationRouter(interactor: interactor,
                                       viewController: viewController,
                                       folderDetailBuilder: folderDetailBuilder)
    }
}

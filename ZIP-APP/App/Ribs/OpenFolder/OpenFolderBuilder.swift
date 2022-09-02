//
//  OpenFolderBuilder.swift
//  ZIP-APP
//
//

import RIBs

protocol OpenFolderDependency: Dependency {

}

final class OpenFolderComponent: Component<OpenFolderDependency> {
    var viewController: OpenFolderViewController

    init(dependency: OpenFolderDependency, viewController: OpenFolderViewController) {
        self.viewController = viewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol OpenFolderBuildable: Buildable {
    func build(withListener listener: OpenFolderListener, url: URL) -> OpenFolderRouting
}

final class OpenFolderBuilder: Builder<OpenFolderDependency>, OpenFolderBuildable {

    override init(dependency: OpenFolderDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: OpenFolderListener, url: URL) -> OpenFolderRouting {
        let viewController = OpenFolderViewController()
        let component = OpenFolderComponent(dependency: dependency, viewController: viewController)
        let interactor = OpenFolderInteractor(presenter: viewController, url: url)
        interactor.listener = listener

        let folderDetailBuilder = DIContainer.resolve(FolderDetailBuildable.self, agrument: component)
        let renameItemBuilder = DIContainer.resolve(RenameItemBuildable.self, agrument: component)
        let selectDestinationBuilder = DIContainer.resolve(SelectDestinationBuildable.self, agrument: component)
        let createFolderBuilder = DIContainer.resolve(CreateFolderBuildable.self, agrument: component)
        let addFilePopupBuilder = DIContainer.resolve(AddFilePopupBuildable.self, agrument: component)

        return OpenFolderRouter(interactor: interactor,
                                viewController: viewController,
                                folderDetailBuilder: folderDetailBuilder,
                                renameItemBuilder: renameItemBuilder,
                                selectDestinationBuilder: selectDestinationBuilder,
                                createFolderBuilder: createFolderBuilder,
                                addFilePopupBuilder: addFilePopupBuilder)
    }
}

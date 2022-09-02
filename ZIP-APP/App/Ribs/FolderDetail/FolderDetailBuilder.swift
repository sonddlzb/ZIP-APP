//
//  FolderDetailBuilder.swift
//  Zip
//
//  Created by Son Dao on 20/06/2022.
//

import RIBs

protocol FolderDetailDependency: Dependency {

}

final class FolderDetailComponent: Component<FolderDetailDependency> {
}

// MARK: - Builder

protocol FolderDetailBuildable: Buildable {
    func build(withListener listener: FolderDetailListener, url: URL, canSelectItem: Bool, isOnlyFolderDisplayed: Bool) -> FolderDetailRouting
    func build(withListener listener: FolderDetailListener, url: URL, canSelectItem: Bool, isOnlyFolderDisplayed: Bool, exceptedURLs: [URL]) -> FolderDetailRouting
}

final class FolderDetailBuilder: Builder<FolderDetailDependency>, FolderDetailBuildable {

    override init(dependency: FolderDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FolderDetailListener, url: URL, canSelectItem: Bool, isOnlyFolderDisplayed: Bool, exceptedURLs: [URL]) -> FolderDetailRouting {
        // let component = FolderDetailComponent(dependency: dependency)
        let viewController = FolderDetailViewController()
        let interactor = FolderDetailInteractor(presenter: viewController, url: url, canSelectItem: canSelectItem, isOnlyFolderDisplayed: isOnlyFolderDisplayed, exceptedURLs: exceptedURLs)
        interactor.listener = listener
        return FolderDetailRouter(interactor: interactor, viewController: viewController)
    }

    func build(withListener listener: FolderDetailListener, url: URL, canSelectItem: Bool, isOnlyFolderDisplayed: Bool) -> FolderDetailRouting {
        return self.build(withListener: listener, url: url, canSelectItem: canSelectItem, isOnlyFolderDisplayed: isOnlyFolderDisplayed, exceptedURLs: [])
    }
}

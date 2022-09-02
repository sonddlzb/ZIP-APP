//
//  HomeBuilder.swift
//  Zip
//
//  Created by Linh Nguyen Duc on 20/06/2022.
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

//        let selectMediaBuilder = DIContainer.resolve(SelectMediaBuildable.self, agrument: component)
//        let settingBuilder = DIContainer.resolve(SettingBuildable.self, agrument: component)
//        let openFolderBuilder = DIContainer.resolve(OpenFolderBuildable.self, agrument: component)
//        let selectCategoryAudioBuilder = DIContainer.resolve(SelectCategoryAudioBuildable.self, agrument: component)
//        let compressBuilder = DIContainer.resolve(CompressBuildable.self, agrument: component)
//        let extractBuilder = DIContainer.resolve(ExtractBuildable.self, agrument: component)
//        let addFileFromGoogleDriveBuilder = DIContainer.resolve(AddFileFromGoogleDriveBuildable.self, agrument: component)
//        let addFileFromDropboxBuilder = DIContainer.resolve(AddFileFromDropboxBuildable.self, agrument: component)
//        let addFileFromOneDriveBuilder = DIContainer.resolve(AddFileFromOneDriveBuildable.self, agrument: component)

        return HomeRouter(interactor: interactor,
                          viewController: viewController)
    }
}

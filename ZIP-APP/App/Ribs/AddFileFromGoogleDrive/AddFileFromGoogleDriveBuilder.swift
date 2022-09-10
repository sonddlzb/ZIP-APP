//
//  AddFileFromGoogleDriveBuilder.swift
//  Zip
//
//

import RIBs

protocol AddFileFromGoogleDriveDependency: Dependency {
    var addFileFromGoogleDriveViewController: AddFileFromGoogleDriveViewControllable { get }
}

final class AddFileFromGoogleDriveComponent: Component<AddFileFromGoogleDriveDependency> {
    fileprivate var addFileFromGoogleDriveViewController: AddFileFromGoogleDriveViewControllable {
        return dependency.addFileFromGoogleDriveViewController
    }
}

// MARK: - Builder

protocol AddFileFromGoogleDriveBuildable: Buildable {
    func build(withListener listener: AddFileFromGoogleDriveListener, downloadFolderURL: URL) -> AddFileFromGoogleDriveRouting
}

final class AddFileFromGoogleDriveBuilder: Builder<AddFileFromGoogleDriveDependency>, AddFileFromGoogleDriveBuildable {

    override init(dependency: AddFileFromGoogleDriveDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AddFileFromGoogleDriveListener, downloadFolderURL: URL) -> AddFileFromGoogleDriveRouting {
        let component = AddFileFromGoogleDriveComponent(dependency: dependency)
        let interactor = AddFileFromGoogleDriveInteractor(downloadFolderURL: downloadFolderURL)
        interactor.listener = listener

        let openCloudBuilder = DIContainer.resolve(OpenCloudBuildable.self, agrument: component)

        return AddFileFromGoogleDriveRouter(interactor: interactor,
                                            viewController: component.addFileFromGoogleDriveViewController,
                                            openCloudBuilder: openCloudBuilder)
    }
}

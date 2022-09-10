//
//  OpenCloudBuilder.swift
//  Zip
//
//

import RIBs

protocol OpenCloudDependency: Dependency {

}

final class OpenCloudComponent: Component<OpenCloudDependency> {
}

// MARK: - Builder

protocol OpenCloudBuildable: Buildable {
    func build(withListener listener: OpenCloudListener, cloudItem: CloudItem, parentId: String?, cloudService: CloudService) -> OpenCloudRouting
}

final class OpenCloudBuilder: Builder<OpenCloudDependency>, OpenCloudBuildable {

    override init(dependency: OpenCloudDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: OpenCloudListener, cloudItem: CloudItem, parentId: String?, cloudService: CloudService) -> OpenCloudRouting {
        let component = OpenCloudComponent(dependency: dependency)
        let viewController = OpenCloudViewController()

        let interactor = OpenCloudInteractor(presenter: viewController,
                                             cloudItem: cloudItem,
                                             parentId: parentId,
                                             cloudService: cloudService)
        interactor.listener = listener

        let openCloudBuilder = DIContainer.resolve(OpenCloudBuildable.self, agrument: component)

        return OpenCloudRouter(interactor: interactor,
                               viewController: viewController,
                               openCloudBuilder: openCloudBuilder)
    }
}

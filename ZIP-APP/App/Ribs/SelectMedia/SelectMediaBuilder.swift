//
//  SelectMediaBuilder.swift
//  Zip
//
//  Created by đào sơn on 03/09/2022.
//

import RIBs

protocol SelectMediaDependency: Dependency {

}

final class SelectMediaComponent: Component<SelectMediaDependency> {
}

// MARK: - Builder

protocol SelectMediaBuildable: Buildable {
    func build(withListener listener: SelectMediaListener) -> SelectMediaRouting
}

final class SelectMediaBuilder: Builder<SelectMediaDependency>, SelectMediaBuildable {

    override init(dependency: SelectMediaDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SelectMediaListener) -> SelectMediaRouting {
        let component = SelectMediaComponent(dependency: dependency)
        let viewController = SelectMediaViewController()
        let interactor = SelectMediaInteractor(presenter: viewController)
        interactor.listener = listener
        let previewImageBuilder = DIContainer.resolve(PreviewImageBuildable.self, agrument: component)
        let previewVideoBuilder = DIContainer.resolve(PreviewVideoBuildable.self, agrument: component)
        return SelectMediaRouter(interactor: interactor,
                                 viewController: viewController,
                                 previewImageBuilder: previewImageBuilder,
                                 previewVideoBuilder: previewVideoBuilder)
    }
}

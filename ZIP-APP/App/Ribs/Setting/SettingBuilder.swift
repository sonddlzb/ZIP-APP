//
//  SettingBuilder.swift
//  Zip
//
//  Created by đào sơn on 31/08/2022.
//

import RIBs

protocol SettingDependency: Dependency {

}

final class SettingComponent: Component<SettingDependency> {
}

// MARK: - Builder

protocol SettingBuildable: Buildable {
    func build(withListener listener: SettingListener) -> SettingRouting
}

final class SettingBuilder: Builder<SettingDependency>, SettingBuildable {

    override init(dependency: SettingDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SettingListener) -> SettingRouting {
        let component = SettingComponent(dependency: dependency)
        let viewController = SettingViewController()
        let createPasswordBuilder = DIContainer.resolve(CreatePasswordBuildable.self, agrument: component)
        let changePasswordBuilder = DIContainer.resolve(ChangePasswordBuildable.self, agrument: component)
        let interactor = SettingInteractor(presenter: viewController)
        interactor.listener = listener
        return SettingRouter(interactor: interactor,
                             viewController: viewController,
                             createPasswordBuilder: createPasswordBuilder,
                             changePasswordBuilder: changePasswordBuilder)
    }
}

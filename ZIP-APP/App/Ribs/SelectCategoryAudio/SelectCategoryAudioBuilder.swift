//
//  SelectCategoryAudioBuilder.swift
//  Zip
//
//

import RIBs

protocol SelectCategoryAudioDependency: Dependency {

}

final class SelectCategoryAudioComponent: Component<SelectCategoryAudioDependency> {
}

// MARK: - Builder

protocol SelectCategoryAudioBuildable: Buildable {
    func build(withListener listener: SelectCategoryAudioListener) -> SelectCategoryAudioRouting
}

final class SelectCategoryAudioBuilder: Builder<SelectCategoryAudioDependency>, SelectCategoryAudioBuildable {

    override init(dependency: SelectCategoryAudioDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SelectCategoryAudioListener) -> SelectCategoryAudioRouting {
        let component = SelectCategoryAudioComponent(dependency: dependency)
        let viewController = SelectCategoryAudioViewController()

        let interactor = SelectCategoryAudioInteractor(presenter: viewController)
        interactor.listener = listener

        let selectAudioBuilder = DIContainer.resolve(SelectAudioBuildable.self, agrument: component)

        return SelectCategoryAudioRouter(interactor: interactor,
                                         viewController: viewController,
                                         selectAudioBuilder: selectAudioBuilder)
    }
}

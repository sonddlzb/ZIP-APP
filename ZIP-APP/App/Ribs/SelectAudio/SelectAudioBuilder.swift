//
//  SelectAudioBuilder.swift
//  Zip
//
//

import RIBs
import MediaPlayer

protocol SelectAudioDependency: Dependency {

}

final class SelectAudioComponent: Component<SelectAudioDependency> {
}

// MARK: - Builder

protocol SelectAudioBuildable: Buildable {
    func build(withListener listener: SelectAudioListener, category: MPMediaItemCollection) -> SelectAudioRouting
}

final class SelectAudioBuilder: Builder<SelectAudioDependency>, SelectAudioBuildable {

    override init(dependency: SelectAudioDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SelectAudioListener, category: MPMediaItemCollection) -> SelectAudioRouting {
        // let component = SelectAudioComponent(dependency: dependency)
        let viewController = SelectAudioViewController()
        let interactor = SelectAudioInteractor(presenter: viewController, category: category)
        interactor.listener = listener
        return SelectAudioRouter(interactor: interactor, viewController: viewController)
    }
}

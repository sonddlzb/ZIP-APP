//
//  ExtractBuilder.swift
//  Zip
//
//

import RIBs

protocol ExtractDependency: Dependency {
    var extractViewController: ExtractViewControllable { get }
}

final class ExtractComponent: Component<ExtractDependency> {
    fileprivate var extractViewController: ExtractViewControllable {
        return dependency.extractViewController
    }
}

// MARK: - Builder

protocol ExtractBuildable: Buildable {
    func build(withListener listener: ExtractListener, zipURL: URL, outputFolderURL: URL) -> ExtractRouting
}

final class ExtractBuilder: Builder<ExtractDependency>, ExtractBuildable {

    override init(dependency: ExtractDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ExtractListener, zipURL: URL, outputFolderURL: URL) -> ExtractRouting {
        let component = ExtractComponent(dependency: dependency)

        let interactor = ExtractInteractor(zipURL: zipURL, outputFolderURL: outputFolderURL)
        interactor.listener = listener

        let inputPasswordBuilder = DIContainer.resolve(InputPasswordBuildable.self, agrument: component)
        let extractLoadingBuilder = DIContainer.resolve(ExtractLoadingBuildable.self, agrument: component)

        return ExtractRouter(interactor: interactor,
                             viewController: component.extractViewController,
                             inputPasswordBuilder: inputPasswordBuilder,
                             extractLoadingBuilder: extractLoadingBuilder)
    }
}

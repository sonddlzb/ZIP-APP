//
//  PreviewImageBuilder.swift
//  Zip
//
//  Created by đào sơn on 03/09/2022.
//

import RIBs
import Photos

protocol PreviewImageDependency: Dependency {

}

final class PreviewImageComponent: Component<PreviewImageDependency> {
}

// MARK: - Builder

protocol PreviewImageBuildable: Buildable {
    func build(withListener listener: PreviewImageListener, asset: PHAsset) -> PreviewImageRouting
    func build(withListener listener: PreviewImageListener, imageURL: URL) -> PreviewImageRouting
}

final class PreviewImageBuilder: Builder<PreviewImageDependency>, PreviewImageBuildable {

    override init(dependency: PreviewImageDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PreviewImageListener, asset: PHAsset) -> PreviewImageRouting {
        return self.build(withListener: listener, asset: asset, imageURL: nil)
    }
    
    func build(withListener listener: PreviewImageListener, imageURL: URL) -> PreviewImageRouting {
        return self.build(withListener: listener, asset: nil, imageURL: imageURL)
    }

    private func build(withListener listener: PreviewImageListener, asset: PHAsset?, imageURL: URL?) -> PreviewImageRouting {
        // let component = PreviewImageComponent(dependency: dependency)
        let viewController = PreviewImageViewController()
        viewController.modalTransitionStyle = .coverVertical
        viewController.modalPresentationStyle = .fullScreen
        let interactor = PreviewImageInteractor(presenter: viewController, asset: asset, imageURL: imageURL)
        interactor.listener = listener
        return PreviewImageRouter(interactor: interactor, viewController: viewController)
    }
}

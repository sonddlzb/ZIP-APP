//
//  CompressBuilder.swift
//  Zip
//
//

import RIBs
import MediaPlayer
import Photos

protocol CompressDependency: Dependency {
    var compressViewController: CompressViewControllable { get }
}

final class CompressComponent: Component<CompressDependency> {
    fileprivate var compressViewController: CompressViewControllable {
        return dependency.compressViewController
    }
}

// MARK: - Builder

protocol CompressBuildable: Buildable {
    func build(withListener listener: CompressListener, inputURLs: [URL], outputFolderURL: URL) -> CompressRouting
    func build(withListener listener: CompressListener, audios: [MPMediaItem], outputFolderURL: URL) -> CompressRouting
    func build(withListener listener: CompressListener, assets: [PHAsset], outputFolderURL: URL) -> CompressRouting
}

final class CompressBuilder: Builder<CompressDependency>, CompressBuildable {

    override init(dependency: CompressDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CompressListener, assets: [PHAsset], outputFolderURL: URL) -> CompressRouting {
        return self.build(withListener: listener, inputValue: .assets(assets), outputFolderURL: outputFolderURL)
    }

    func build(withListener listener: CompressListener, audios: [MPMediaItem], outputFolderURL: URL) -> CompressRouting {
        return self.build(withListener: listener, inputValue: .audios(audios), outputFolderURL: outputFolderURL)
    }

    func build(withListener listener: CompressListener, inputURLs: [URL], outputFolderURL: URL) -> CompressRouting {
        return self.build(withListener: listener, inputValue: .urls(inputURLs), outputFolderURL: outputFolderURL)
    }

    private func build(withListener listener: CompressListener, inputValue: CompressInputValue, outputFolderURL: URL) -> CompressRouting {
        let component = CompressComponent(dependency: dependency)
        let interactor = CompressInteractor(inputValue: inputValue, outputFolderURL: outputFolderURL)
        interactor.listener = listener

        let inputToCompressBuilder = DIContainer.resolve(InputToCompressBuildable.self, agrument: component)
        let compressLoadingBuilder = DIContainer.resolve(CompressLoadingBuildable.self, agrument: component)
        let inputPasswordBuilder = DIContainer.resolve(InputPasswordBuildable.self, agrument: component)

        return CompressRouter(interactor: interactor,
                              viewController: component.compressViewController,
                              inputToCompressBuilder: inputToCompressBuilder,
                              compressLoadingBuilder: compressLoadingBuilder,
                              inputPasswordBuilder: inputPasswordBuilder)
    }
}

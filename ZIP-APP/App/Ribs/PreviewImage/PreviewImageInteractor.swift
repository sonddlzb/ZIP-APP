//
//  PreviewImageInteractor.swift
//  Zip
//
//  Created by đào sơn on 03/09/2022
//

import RIBs
import RxSwift
import Photos

protocol PreviewImageRouting: ViewableRouting {
}

protocol PreviewImagePresentable: Presentable {
    var listener: PreviewImagePresentableListener? { get set }
    func bind(viewModel: PreviewImageViewModel)
}

protocol PreviewImageListener: AnyObject {
    func previewImageWantToDismiss()
}

final class PreviewImageInteractor: PresentableInteractor<PreviewImagePresentable>, PreviewImageInteractable {

    var viewModel: PreviewImageViewModel
    weak var router: PreviewImageRouting?
    weak var listener: PreviewImageListener?

    init(presenter: PreviewImagePresentable, asset: PHAsset?, imageURL: URL?) {
        self.viewModel = PreviewImageViewModel(asset: asset, imageURL: imageURL)
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        presenter.bind(viewModel: self.viewModel)
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: PreviewImagePresentableListener
extension PreviewImageInteractor: PreviewImagePresentableListener {
    func didTapCancelButton() {
        listener?.previewImageWantToDismiss()
    }
}

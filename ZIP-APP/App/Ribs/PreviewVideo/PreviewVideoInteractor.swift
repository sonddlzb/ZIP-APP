//
//  PreviewVideoInteractor.swift
//  Zip
//
//  Created by đào sơn on 03/09/2022.
//

import RIBs
import RxSwift
import Photos

protocol PreviewVideoRouting: ViewableRouting {
}

protocol PreviewVideoPresentable: Presentable {
    var listener: PreviewVideoPresentableListener? { get set }
    func bind(viewModel: PreviewVideoViewModel)
}

protocol PreviewVideoListener: AnyObject {
    func previewVideoWantToDismiss()
}

final class PreviewVideoInteractor: PresentableInteractor<PreviewVideoPresentable>, PreviewVideoInteractable {

    weak var router: PreviewVideoRouting?
    weak var listener: PreviewVideoListener?
    var viewModel: PreviewVideoViewModel

    init(presenter: PreviewVideoPresentable, asset: PHAsset?, videoURL: URL?) {
        self.viewModel = PreviewVideoViewModel(asset: asset, videoURL: videoURL)
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

// MARK: PreviewVideoPresentableListener
extension PreviewVideoInteractor: PreviewVideoPresentableListener {
    func didTapCancelButton() {
        listener?.previewVideoWantToDismiss()
    }

    func updateCurrentVideoTime(currentTime: Double) {
        viewModel.currentVideoTime = currentTime
        self.presenter.bind(viewModel: viewModel)
    }
}

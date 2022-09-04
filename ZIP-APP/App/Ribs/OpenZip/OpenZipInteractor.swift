//
//  OpenZipInteractor.swift
//  Zip
//
//

import RIBs
import RxSwift

protocol OpenZipRouting: ViewableRouting {
}

protocol OpenZipPresentable: Presentable {
    var listener: OpenZipPresentableListener? { get set }
    func bind(viewModel: OpenZipViewModel)
}

protocol OpenZipListener: AnyObject {
    func openZipWantToDismiss()
    func openZipWantToExtract(url: URL)
}

final class OpenZipInteractor: PresentableInteractor<OpenZipPresentable>, OpenZipInteractable {

    weak var router: OpenZipRouting?
    weak var listener: OpenZipListener?

    var viewModel: OpenZipViewModel
    init(presenter: OpenZipPresentable, zipURL: URL) {
        self.viewModel = OpenZipViewModel(url: zipURL)
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.presenter.bind(viewModel: self.viewModel)
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - OpenZipPresentableListener
extension OpenZipInteractor: OpenZipPresentableListener {
    func didSelectBack() {
        listener?.openZipWantToDismiss()
    }

    func didSelectExtract() {
        listener?.openZipWantToExtract(url: self.viewModel.url)
    }
}

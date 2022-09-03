//
//  CompressLoadingInteractor.swift
//  Zip
//
//

import RIBs
import RxSwift

protocol CompressLoadingRouting: ViewableRouting {
    func removeViewControllerFromNavigation()
}

protocol CompressLoadingPresentable: Presentable {
    var listener: CompressLoadingPresentableListener? { get set }
}

protocol CompressLoadingListener: AnyObject {
}

final class CompressLoadingInteractor: PresentableInteractor<CompressLoadingPresentable>, CompressLoadingInteractable, CompressLoadingPresentableListener {

    weak var router: CompressLoadingRouting?
    weak var listener: CompressLoadingListener?

    override init(presenter: CompressLoadingPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
        self.router?.removeViewControllerFromNavigation()
    }
}

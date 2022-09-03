//
//  ExtractLoadingInteractor.swift
//  Zip
//
//

import RIBs
import RxSwift

protocol ExtractLoadingRouting: ViewableRouting {
}

protocol ExtractLoadingPresentable: Presentable {
    var listener: ExtractLoadingPresentableListener? { get set }
}

protocol ExtractLoadingListener: AnyObject {
}

final class ExtractLoadingInteractor: PresentableInteractor<ExtractLoadingPresentable>, ExtractLoadingInteractable, ExtractLoadingPresentableListener {

    weak var router: ExtractLoadingRouting?
    weak var listener: ExtractLoadingListener?

    override init(presenter: ExtractLoadingPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

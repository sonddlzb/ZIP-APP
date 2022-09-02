//
//  RootInteractor.swift
//  Zip
//
//

import RIBs
import RxSwift

protocol RootRouting: ViewableRouting {
    func routeToHome()
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
}

protocol RootListener: AnyObject {
}

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable, RootPresentableListener {

    weak var router: RootRouting?
    weak var listener: RootListener?

    override init(presenter: RootPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.createMyFileFolderIfNeeded()
        self.router?.routeToHome()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    private func createMyFileFolderIfNeeded() {
        FileManager.createDirIfNeeded(path: FileManager.myFileURL().path)
    }
}

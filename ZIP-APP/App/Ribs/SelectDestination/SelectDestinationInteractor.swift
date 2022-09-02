//
//  SelectDestinationInteractor.swift
//  Zip
//
//

import RIBs
import RxSwift

protocol SelectDestinationRouting: ViewableRouting {
    func reloadItems()
    func reloadFolderDetail(url: URL)
    func embedFolderDetail(url: URL, exceptedURLs: [URL])
    func setBottomContentInsetForFolderDetail(_ bottom: CGFloat)
}

protocol SelectDestinationPresentable: Presentable {
    var listener: SelectDestinationPresentableListener? { get set }
    func bind(viewModel: SelectDestinationNavigationViewModel)
}

protocol SelectDestinationListener: AnyObject {
    func selectDestinationWantToDismiss()
    func selectDestinationDidSelectMoveTo(url: URL)
    func selectDestinationWantToCreateFolder(in url: URL)
}

final class SelectDestinationInteractor: PresentableInteractor<SelectDestinationPresentable> {

    weak var router: SelectDestinationRouting?
    weak var listener: SelectDestinationListener?

    var viewModel: SelectDestinationNavigationViewModel
    var exceptedURLs: [URL]
    init(presenter: SelectDestinationPresentable, exceptedURLs: [URL]) {
        self.viewModel = SelectDestinationNavigationViewModel(url: FileManager.myFileURL())
        self.exceptedURLs = exceptedURLs
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.router?.embedFolderDetail(url: self.viewModel.url, exceptedURLs: exceptedURLs)
        self.presenter.bind(viewModel: self.viewModel)
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - SelectDestinationPresentableListener
extension SelectDestinationInteractor: SelectDestinationPresentableListener {
    func didSelectMoveHere() {
        listener?.selectDestinationDidSelectMoveTo(url: self.viewModel.url)
    }

    func didSelectClose() {
        listener?.selectDestinationWantToDismiss()
    }

    func didSelectCreateNewFolder() {
        listener?.selectDestinationWantToCreateFolder(in: self.viewModel.url)
    }

    func didSelectRouteTo(url: URL) {
        self.viewModel = SelectDestinationNavigationViewModel(url: url)
        self.presenter.bind(viewModel: self.viewModel)
    }

    func needReloadFolderDetail(url: URL) {
        self.router?.reloadFolderDetail(url: url)
    }

    func setBottomContentInsetForContentView(_ bottom: CGFloat) {
        self.router?.setBottomContentInsetForFolderDetail(bottom)
    }
}

// MARK: - SelectDestinationInteractable
extension SelectDestinationInteractor: SelectDestinationInteractable {
    func reloadItems() {
        self.viewModel = SelectDestinationNavigationViewModel(url: self.viewModel.url)
        self.presenter.bind(viewModel: self.viewModel)
    }
}

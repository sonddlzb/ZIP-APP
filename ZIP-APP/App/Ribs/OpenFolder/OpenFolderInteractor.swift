//
//  OpenFolderInteractor.swift
//  ZIP-APP
//
//

import RIBs
import RxSwift

protocol OpenFolderRoutingAndFolderDetailBridge {
    func embedFolderDetail(url: URL)
    func updateBottomContentInsetForFolderDetail(_ value: CGFloat)
    func reloadFolderDetail(url: URL, needHighlightItem url: URL?)
    func updateUIForOptionViewState(isVisible: Bool)
    func openFolderWantToSelectAllItem()
    func openFolderWantToUnselectAllItem()
    func openFolderDidMoveItem(fromURL: URL, toURL: URL)
    func openFolderDidDeleteSelectedItems()
}

protocol OpenFolderRouting: ViewableRouting, OpenFolderRoutingAndFolderDetailBridge {
    func routeToRenameItem(inputURL: URL)
    func dismissRenameItem()
    func routeToSelectDestination(exceptedURLs: [URL])
    func reloadSelectDestination()
    func dismissSelectDestination()
    func routeToCreateFolder(inputURL: URL)
    func dismissCreateFolder()
    func routeToAddFilePopup()
    func dismissAddFilePopup(completion: (() -> Void)?)

    func resetScreen(highlightedItemURL: URL?)
    func displaySharingURLs(_ urls: [URL])
    func openFolder(url: URL)
}

protocol OpenFolderPresentable: Presentable {
    var listener: OpenFolderPresentableListener? { get set }
    func bind(viewModel: OpenFolderViewModel)
    func displayDeleteDialog(viewModel: OpenFolderViewModel)
}

protocol OpenFolderListener: AnyObject {
    func openFolderWantToDismiss()
    func openFolderWantToAddFileFromPhoto(folderURL: URL)
    func openFolderWantToAddFileFromAudio(folderURL: URL)
//    func openFolderWantToAddFileFromDocumentBrowser(folderURL: URL)
//    func openFolderWantToAddFileFromGoogleDrive(folderURL: URL)
//    func openFolderWantToAddFileFromOnedrive(folderURL: URL)
//    func openFolderWantToAddFileFromDropbox(folderURL: URL)
//    func openFolderWantToCompress(inputURLs: [URL], outputFolderURL: URL)
//    func openFolderWantToExtract(zipURL: URL, outputFolderURL: URL)
}

final class OpenFolderInteractor: PresentableInteractor<OpenFolderPresentable> {

    weak var router: OpenFolderRouting?
    weak var listener: OpenFolderListener?

    var viewModel: OpenFolderViewModel

    init(presenter: OpenFolderPresentable, url: URL) {
        self.viewModel = OpenFolderViewModel(url: url, isSelectingModeEnabled: false)
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.presenter.bind(viewModel: self.viewModel)
        self.router?.embedFolderDetail(url: self.viewModel.url)
    }

    override func willResignActive() {
        super.willResignActive()
    }

    // MARK: - Helper
    private func handleDeletingSelectedItems() {
        self.viewModel.selectedURLs.forEach({ try? FileManager.default.removeItem(at: $0) })
        self.viewModel.unselectAll()
        self.viewModel.isSelectingModeEnabled = false
        self.router?.openFolderDidDeleteSelectedItems()
        self.presenter.bind(viewModel: self.viewModel)
    }
}

// MARK: - OpenFolderInteractable
extension OpenFolderInteractor: OpenFolderInteractable {
    func openFolder(url: URL) {
        self.viewModel = OpenFolderViewModel(url: url, isSelectingModeEnabled: false)
        self.presenter.bind(viewModel: self.viewModel)
    }

    func resetScreen(highlightedItemURL: URL?) {
        self.viewModel.isSelectingModeEnabled = false
        self.viewModel.unselectAll()
        self.router?.openFolderWantToUnselectAllItem()
        self.router?.reloadFolderDetail(url: self.viewModel.url, needHighlightItem: highlightedItemURL)
        self.presenter.bind(viewModel: self.viewModel)
    }
}

// MARK: - OpenFolderPresentableListener
extension OpenFolderInteractor: OpenFolderPresentableListener {
    func updateBottomContentInset(_ value: CGFloat) {
        self.router?.updateBottomContentInsetForFolderDetail(value)
    }

    func didDisableSelectingMode() {
        self.viewModel.isSelectingModeEnabled = false
        self.viewModel.unselectAll()
        self.router?.openFolderWantToUnselectAllItem()
        self.presenter.bind(viewModel: self.viewModel)
    }

    func didSelectDeleteOnDialog() {
        self.handleDeletingSelectedItems()
    }

    func didSelectAddFile() {
        self.router?.routeToAddFilePopup()
    }

    func didSelectAddFileFromPhoto() {
        listener?.openFolderWantToAddFileFromPhoto(folderURL: self.viewModel.url)
    }

    func didSelectAddFileFromAudio() {
        listener?.openFolderWantToAddFileFromAudio(folderURL: self.viewModel.url)
    }

    func didSelectAddFileFromDocumentBrowser() {
//        listener?.openFolderWantToAddFileFromDocumentBrowser(folderURL: self.viewModel.url)
    }

    func didSelectAddFileFromGoogleDrive() {
//        listener?.openFolderWantToAddFileFromGoogleDrive(folderURL: self.viewModel.url)
    }

    func didSelectAddFileFromOnedrive() {
//        listener?.openFolderWantToAddFileFromOnedrive(folderURL: self.viewModel.url)
    }

    func didSelectAddFileFromDropbox() {
//        listener?.openFolderWantToAddFileFromDropbox(folderURL: self.viewModel.url)
    }

    func didSelectCreateNewFolder() {
        self.router?.routeToCreateFolder(inputURL: self.viewModel.url)
    }

    func didSelectBack() {
        if !self.viewModel.popLastComponent() {
            listener?.openFolderWantToDismiss()
        } else {
            self.viewModel.isSelectingModeEnabled = false
            self.presenter.bind(viewModel: self.viewModel)
        }
    }

    func didSelectAll() {
        if self.viewModel.isSelectedAll() {
            self.router?.openFolderWantToUnselectAllItem()
            self.viewModel.unselectAll()
        } else {
            self.router?.openFolderWantToSelectAllItem()
            self.viewModel.selectAll()
        }

        self.presenter.bind(viewModel: self.viewModel)
    }

    func didUnselectAll() {
        guard !self.viewModel.isSelectedItemsEmpty() else {
            return
        }

        self.router?.openFolderWantToUnselectAllItem()
        self.viewModel.unselectAll()
        self.presenter.bind(viewModel: self.viewModel)
    }

    func didUpdateOptionViewState(isVisible: Bool) {
        self.router?.updateUIForOptionViewState(isVisible: isVisible)
    }

    func needReloadFolderDetail(url: URL) {
        self.router?.reloadFolderDetail(url: url, needHighlightItem: nil)
    }

    func didSelectOptionAction(_ action: OptionActionType) {
        switch action {
        case .rename:
            if let inputURL = self.viewModel.selectedURLs.first {
                self.router?.routeToRenameItem(inputURL: inputURL)
            }

        case .share:
            if !self.viewModel.selectedURLs.isEmpty {
                self.router?.displaySharingURLs(self.viewModel.selectedURLs)
            }

        case .delete:
            self.presenter.displayDeleteDialog(viewModel: self.viewModel)

        case .move:
            self.router?.routeToSelectDestination(exceptedURLs: self.viewModel.selectedURLs)

        default:
            break
        }
    }
}

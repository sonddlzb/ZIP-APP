//
//  FolderDetailInteractor.swift
//  Zip
//
//

import RIBs
import RxSwift

protocol FolderDetailRouting: ViewableRouting {
    func updateUIForOptionViewState(isVisible: Bool)
    func reloadItems(folderURL: URL, highlightedItemURL: URL?)
    func moveItem(fromURL: URL, toURL: URL)
    func selectAll()
    func unselectAll()
    func deleteSelectedItems()
    func setBottomContentInset(_ bottom: CGFloat)
}

protocol FolderDetailPresentable: Presentable {
    var listener: FolderDetailPresentableListener? { get set }
    func bind(viewModel: FolderDetailViewModel, highlightedItemURL: URL?)
}

protocol FolderDetailListener: AnyObject {
    func folderDetailDidSelectItem(urls: [URL])
    func folderDetailDidSelectOpenURL(_ url: URL)
}

final class FolderDetailInteractor: PresentableInteractor<FolderDetailPresentable> {

    weak var router: FolderDetailRouting?
    weak var listener: FolderDetailListener?

    private var viewModel: FolderDetailViewModel
    private var canSelectItem: Bool
    private var exceptedURLs: [URL]

    init(presenter: FolderDetailPresentable, url: URL, canSelectItem: Bool, isOnlyFolderDisplayed: Bool, exceptedURLs: [URL]) {
        self.viewModel = FolderDetailViewModel(url: url, isOnlyFolderDisplayed: isOnlyFolderDisplayed, exceptedURLs: exceptedURLs)
        self.exceptedURLs = exceptedURLs
        self.canSelectItem = canSelectItem
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()

        self.refreshContentAndBindData(highlightedItemURL: nil)
    }

    override func willResignActive() {
        super.willResignActive()
    }

    private func refreshContentAndBindData(highlightedItemURL: URL?) {
        DispatchQueue.global().async {
            self.viewModel.refreshContents()
            DispatchQueue.main.async {
                self.presenter.bind(viewModel: self.viewModel, highlightedItemURL: highlightedItemURL)
            }
        }
    }
}

// MARK: - FolderDetailInteractable
extension FolderDetailInteractor: FolderDetailInteractable {
    func deleteSelectedItems() {
        self.viewModel.unselectAll()
        self.viewModel.refreshContents()
    }

    func reloadItems(folderURL: URL, highlightedItemURL: URL?) {
        if folderURL.path != self.viewModel.url.path {
            self.viewModel = FolderDetailViewModel(url: folderURL, isOnlyFolderDisplayed: self.viewModel.isOnlyFolderDisplayed, exceptedURLs: self.exceptedURLs, contentOffsetManager: self.viewModel.contentOffsetManager)
        }

        self.refreshContentAndBindData(highlightedItemURL: highlightedItemURL)
    }

    func selectAll() {
        if canSelectItem {
            self.viewModel.selectAll()
            self.presenter.bind(viewModel: viewModel, highlightedItemURL: nil)
        }
    }

    func unselectAll() {
        self.viewModel.unselectAll()
        self.viewModel.turnOffSelectedMode()
        self.presenter.bind(viewModel: viewModel, highlightedItemURL: nil)
    }

    func moveItem(fromURL: URL, toURL: URL) {
        self.viewModel.move(fromURL: fromURL, toURL: toURL)
    }
}

// MARK: - FolderDetailPresentableListener
extension FolderDetailInteractor: FolderDetailPresentableListener {
    func needSaveContentOffset(url: URL, contentOffsetY: CGFloat) {
        self.viewModel.save(url: url, contentOffsetY: contentOffsetY)
    }

    func didLongPress(on itemViewModel: FolderDetailItemViewModel) {
        guard self.viewModel.selectedURLs().isEmpty && canSelectItem else {
            return
        }

        self.viewModel.select(itemViewModel: itemViewModel)
        self.presenter.bind(viewModel: self.viewModel, highlightedItemURL: nil)
        listener?.folderDetailDidSelectItem(urls: self.viewModel.selectedURLs())
    }

    func didPress(on itemViewModel: FolderDetailItemViewModel) {
        guard !self.viewModel.selectedURLs().isEmpty || self.viewModel.inOnSelectedMode else {
            listener?.folderDetailDidSelectOpenURL(itemViewModel.url)
            return
        }

        guard canSelectItem else {
            return
        }

        if self.viewModel.isItemSelected(itemViewModel) {
            self.viewModel.unselect(itemViewModel: itemViewModel)
        } else {
            self.viewModel.select(itemViewModel: itemViewModel)
        }

        self.presenter.bind(viewModel: self.viewModel, highlightedItemURL: nil)
        listener?.folderDetailDidSelectItem(urls: self.viewModel.selectedURLs())
    }
}

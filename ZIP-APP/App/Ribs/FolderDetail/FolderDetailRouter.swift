//
//  FolderDetailRouter.swift
//  Zip
//
//

import RIBs

protocol FolderDetailInteractable: Interactable {
    var router: FolderDetailRouting? { get set }
    var listener: FolderDetailListener? { get set }
    func reloadItems(folderURL: URL, highlightedItemURL: URL?)
    func moveItem(fromURL: URL, toURL: URL)
    func selectAll()
    func unselectAll()
    func deleteSelectedItems()
}

protocol FolderDetailViewControllable: ViewControllable {
    func updateUIForOptionViewState(isVisible: Bool)
    func setBottomContentInset(_ bottom: CGFloat)
}

final class FolderDetailRouter: ViewableRouter<FolderDetailInteractable, FolderDetailViewControllable> {

    override init(interactor: FolderDetailInteractable, viewController: FolderDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - FolderDetailRouting
extension FolderDetailRouter: FolderDetailRouting {
    func reloadItems(folderURL: URL, highlightedItemURL: URL?) {
        self.interactor.reloadItems(folderURL: folderURL, highlightedItemURL: highlightedItemURL)
    }

    func selectAll() {
        self.interactor.selectAll()
    }

    func unselectAll() {
        self.interactor.unselectAll()
    }

    func updateUIForOptionViewState(isVisible: Bool) {
        self.viewController.updateUIForOptionViewState(isVisible: isVisible)
    }

    func moveItem(fromURL: URL, toURL: URL) {
        self.interactor.moveItem(fromURL: fromURL, toURL: toURL)
    }

    func deleteSelectedItems() {
        self.interactor.deleteSelectedItems()
    }

    func setBottomContentInset(_ bottom: CGFloat) {
        self.viewController.setBottomContentInset(bottom)
    }
}

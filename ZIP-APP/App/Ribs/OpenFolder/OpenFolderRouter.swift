//
//  OpenFolderRouter.swift
//  ZIP-APP
//
//

import RIBs
import Foundation

protocol OpenFolderInteractable: Interactable, FolderDetailListener, RenameItemListener, SelectDestinationListener, CreateFolderListener, AddFilePopupListener {
    var router: OpenFolderRouting? { get set }
    var listener: OpenFolderListener? { get set }
    func resetScreen(highlightedItemURL: URL?)
    func openFolder(url: URL)
}

protocol OpenFolderViewControllable: ViewControllable {
    func embedViewController(_ viewController: ViewControllable)
}

final class OpenFolderRouter: ViewableRouter<OpenFolderInteractable, OpenFolderViewControllable> {
    var folderDetailBuilder: FolderDetailBuildable
    var folderDetailRouter: FolderDetailRouting?

    var renameItemBuilder: RenameItemBuildable
    var renameItemRouter: RenameItemRouting?

    var selectDestinationBuilder: SelectDestinationBuildable
    var selectDestinationRouter: SelectDestinationRouting?

    var createFolderBuilder: CreateFolderBuildable
    var createFolderRouter: CreateFolderRouting?

    var addFilePopupBuilder: AddFilePopupBuildable
    var addFilePopupRouter: AddFilePopupRouting?

    init(interactor: OpenFolderInteractable,
         viewController: OpenFolderViewControllable,
         folderDetailBuilder: FolderDetailBuildable,
         renameItemBuilder: RenameItemBuildable,
         selectDestinationBuilder: SelectDestinationBuildable,
         createFolderBuilder: CreateFolderBuildable,
         addFilePopupBuilder: AddFilePopupBuildable) {
        self.folderDetailBuilder = folderDetailBuilder
        self.renameItemBuilder = renameItemBuilder
        self.selectDestinationBuilder = selectDestinationBuilder
        self.createFolderBuilder = createFolderBuilder
        self.addFilePopupBuilder = addFilePopupBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    // MARK: - Helper
    private func topNavigation() -> UINavigationController {
        var navigation = self.viewController.uiviewController.navigationController!
        while let nextNavigation = navigation.presentedViewController as? UINavigationController {
            navigation = nextNavigation
        }

        return navigation
    }
}

// MARK: - OpenFolderRouting
extension OpenFolderRouter: OpenFolderRouting {
    func routeToCreateFolder(inputURL: URL) {
        let router = createFolderBuilder.build(withListener: self.interactor, inputURL: inputURL)
        let topNavigation = self.topNavigation()
        topNavigation.present(router.viewControllable.uiviewController, animated: true)
        attachChild(router)
        self.createFolderRouter = router
    }

    func dismissCreateFolder() {
        guard let router = self.createFolderRouter else {
            return
        }

        router.viewControllable.dismiss()
        detachChild(router)
        self.createFolderRouter = nil
    }

    func routeToRenameItem(inputURL: URL) {
        let router = self.renameItemBuilder.build(withListener: self.interactor, inputURL: inputURL)
        self.viewController.present(viewControllable: router.viewControllable)
        attachChild(router)
        self.renameItemRouter = router
    }

    func dismissRenameItem() {
        guard let router = self.renameItemRouter else {
            return
        }

        self.viewControllable.dismiss()
        detachChild(router)
        self.renameItemRouter = nil
    }

    func routeToSelectDestination(exceptedURLs: [URL]) {
        let router = selectDestinationBuilder.build(withListener: self.interactor, exceptedURLs: exceptedURLs)
        self.viewController.present(viewControllable: router.viewControllable)
        attachChild(router)
        self.selectDestinationRouter = router
    }

    func reloadSelectDestination() {
        self.selectDestinationRouter?.reloadItems()
    }

    func dismissSelectDestination() {
        guard let router = selectDestinationRouter else {
            return
        }

        self.viewControllable.dismiss()
        detachChild(router)
        self.selectDestinationRouter = nil
    }

    func routeToAddFilePopup() {
        let router = self.addFilePopupBuilder.build(withListener: self.interactor)
        self.viewController.present(viewControllable: router.viewControllable, animated: false)
        attachChild(router)
        self.addFilePopupRouter = router
    }

    func dismissAddFilePopup(completion: (() -> Void)?) {
        guard let router = self.addFilePopupRouter else {
            return
        }

        router.viewControllable.dismiss(animated: false, completion: completion)
        detachChild(router)
        self.addFilePopupRouter = nil
    }

    func displaySharingURLs(_ urls: [URL]) {
        let sharingDialog = UIActivityViewController(activityItems: urls, applicationActivities: nil)
        self.viewController.uiviewController.present(sharingDialog, animated: true)
    }

    func resetScreen(highlightedItemURL: URL?) {
        self.interactor.resetScreen(highlightedItemURL: highlightedItemURL)
    }

    func openFolder(url: URL) {
        self.interactor.openFolder(url: url)
    }

    func updateBottomContentInsetForFolderDetail(_ value: CGFloat) {
        self.folderDetailRouter?.setBottomContentInset(value)
    }
}

// MARK: - OpenFolderRoutingAndFolderDetailBridge
extension OpenFolderRouter: OpenFolderRoutingAndFolderDetailBridge {
    func embedFolderDetail(url: URL) {
        guard self.folderDetailRouter == nil else {
            return
        }

        let router = folderDetailBuilder.build(withListener: self.interactor, url: url, canSelectItem: true, isOnlyFolderDisplayed: false)
        self.viewController.embedViewController(router.viewControllable)
        attachChild(router)
        self.folderDetailRouter = router
    }

    func reloadFolderDetail(url: URL, needHighlightItem highlightedItemURL: URL?) {
        self.folderDetailRouter?.reloadItems(folderURL: url, highlightedItemURL: highlightedItemURL)
    }

    func updateUIForOptionViewState(isVisible: Bool) {
        self.folderDetailRouter?.updateUIForOptionViewState(isVisible: isVisible)
    }

    func openFolderWantToSelectAllItem() {
        self.folderDetailRouter?.selectAll()
    }

    func openFolderWantToUnselectAllItem() {
        self.folderDetailRouter?.unselectAll()
    }

    func openFolderDidMoveItem(fromURL: URL, toURL: URL) {
        self.folderDetailRouter?.moveItem(fromURL: fromURL, toURL: toURL)
    }

    func openFolderDidDeleteSelectedItems() {
        self.folderDetailRouter?.deleteSelectedItems()
    }
}

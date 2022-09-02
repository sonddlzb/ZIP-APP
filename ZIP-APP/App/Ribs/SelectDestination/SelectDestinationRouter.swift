//
//  SelectDestinationRouter.swift
//  Zip
//
//

import RIBs

protocol SelectDestinationInteractable: Interactable, FolderDetailListener {
    var router: SelectDestinationRouting? { get set }
    var listener: SelectDestinationListener? { get set }
    func reloadItems()
}

protocol SelectDestinationViewControllable: ViewControllable {
    func embedViewController(_ viewController: ViewControllable)
}

final class SelectDestinationRouter: ViewableRouter<SelectDestinationInteractable, SelectDestinationViewControllable> {
    var folderDetailBuilder: FolderDetailBuildable
    var folderDetailRouter: FolderDetailRouting?

    init(interactor: SelectDestinationInteractable,
         viewController: SelectDestinationViewControllable,
         folderDetailBuilder: FolderDetailBuildable) {
        self.folderDetailBuilder = folderDetailBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - SelectDestinationRouting
extension SelectDestinationRouter: SelectDestinationRouting {
    func embedFolderDetail(url: URL, exceptedURLs: [URL]) {
        guard self.folderDetailRouter == nil else {
            return
        }

        let router = folderDetailBuilder.build(withListener: self.interactor, url: url, canSelectItem: false, isOnlyFolderDisplayed: true, exceptedURLs: exceptedURLs)
        self.viewController.embedViewController(router.viewControllable)
        attachChild(router)
        self.folderDetailRouter = router
    }

    func reloadFolderDetail(url: URL) {
        self.folderDetailRouter?.reloadItems(folderURL: url, highlightedItemURL: nil)
    }

    func reloadItems() {
        self.interactor.reloadItems()
    }

    func setBottomContentInsetForFolderDetail(_ bottom: CGFloat) {
        self.folderDetailRouter?.setBottomContentInset(bottom)
    }
}

//
//  OpenFolderInteractor+RenameItem.swift
//  Zip
//
//

import Foundation

extension OpenFolderInteractor: RenameItemListener {
    func renameItemWantToDismiss() {
        self.router?.dismissRenameItem()
    }

    func renameItemDidRename(from sourceURL: URL, to destinationURL: URL) {
        self.router?.dismissRenameItem()
        self.router?.openFolderDidMoveItem(fromURL: sourceURL, toURL: destinationURL)
        self.viewModel.rename(fromURL: sourceURL, toURL: destinationURL)
        self.viewModel.unselectAll()
        self.viewModel.isSelectingModeEnabled = false
        self.router?.openFolderWantToUnselectAllItem()
        self.presenter.bind(viewModel: self.viewModel)
    }
}

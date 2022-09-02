//
//  OpenFolderInteractor+SelectDestination.swift
//  Zip
//
//

import Foundation

import TLLogging

extension OpenFolderInteractor: SelectDestinationListener {
    func selectDestinationWantToDismiss() {
        self.router?.dismissSelectDestination()
    }

    func selectDestinationDidSelectMoveTo(url: URL) {
        if self.viewModel.url.path == url.path {
            self.viewModel.unselectAll()
            self.router?.openFolderWantToUnselectAllItem()
            self.viewModel.isSelectingModeEnabled = false
            self.presenter.bind(viewModel: self.viewModel)
            self.router?.dismissSelectDestination()
            self.presenter.showError(message: "The item\(self.viewModel.numberOfSelectedItems() > 1 ? " was" : "s were") located at here")
            return
        }

        var hasError = false
        self.viewModel.selectedURLs.forEach { selectedURL in
            let name = selectedURL.lastPathComponent
            let destinationURL = url.appendingPathComponent(name)
            do {
                try FileManager.default.moveItem(at: selectedURL, to: destinationURL)
            } catch {
                TLLogging.log("Move item error: \(error)")
                hasError = true
            }

            self.router?.openFolderDidMoveItem(fromURL: selectedURL, toURL: destinationURL)
        }

        if hasError {
            self.presenter.showError(message: "Moving items has error")
            self.viewModel.unselectAll()
            self.viewModel.isSelectingModeEnabled = false
            self.router?.openFolderWantToUnselectAllItem()
        } else {
            self.viewModel = OpenFolderViewModel(url: url)
        }

        self.presenter.bind(viewModel: self.viewModel)
        self.router?.dismissSelectDestination()
    }

    func selectDestinationWantToCreateFolder(in url: URL) {
        self.router?.routeToCreateFolder(inputURL: url)
    }
}

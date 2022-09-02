//
//  OpenFolderInteractor+CreateFolder.swift
//  Zip
//
//

import Foundation

extension OpenFolderInteractor: CreateFolderListener {
    func createFolderWantToDismiss() {
        self.router?.dismissCreateFolder()
    }

    func createFolderDidCreated() {
        self.router?.reloadFolderDetail(url: self.viewModel.url, needHighlightItem: nil)
        self.router?.reloadSelectDestination()
        self.presenter.bind(viewModel: self.viewModel)
        self.router?.dismissCreateFolder()
    }
}

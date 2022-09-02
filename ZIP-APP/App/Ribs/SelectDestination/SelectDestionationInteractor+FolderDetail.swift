//
//  SelectDestionationInteractor+FolderDetail.swift
//  Zip
//
//

import Foundation

extension SelectDestinationInteractor: FolderDetailListener {
    func folderDetailDidSelectItem(urls: [URL]) {
        // nothing
    }

    func folderDetailDidSelectOpenURL(_ url: URL) {
        self.viewModel = SelectDestinationNavigationViewModel(url: url)
        self.presenter.bind(viewModel: self.viewModel)
    }
}

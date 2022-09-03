//
//  OpenFolderInteractor+FolderDetail.swift
//  Zip
//
//

import Foundation

extension OpenFolderInteractor: FolderDetailListener {
    func folderDetailDidSelectItem(urls: [URL]) {
        self.viewModel.selectedURLs = urls
        self.viewModel.isSelectingModeEnabled = true
        self.presenter.bind(viewModel: self.viewModel)
    }

    func folderDetailDidSelectOpenURL(_ url: URL) {
        let pathType = FileType.make(extensionPath: url.pathExtension)
        switch pathType {
        case .video:
            self.router?.routeToPreviewVideo(videoURL: url)

        case .image:
            self.router?.routeToPreviewImage(imageURL: url)

        case .folder:
            self.viewModel = OpenFolderViewModel(url: url)
            self.presenter.bind(viewModel: self.viewModel)

        case .zip:
            self.router?.routeToOpenZip(url: url)

        default:
            break
        }
    }
}

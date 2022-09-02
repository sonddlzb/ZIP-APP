//
//  OpenFolderInteractor+AddFilePopup.swift
//  Zip
//
//

import Foundation
import QuartzCore

extension OpenFolderInteractor: AddFilePopupListener {
    func addFilePopupWantToDismiss() {
        self.router?.dismissAddFilePopup(completion: nil)
    }

    func addFilePopupWantToAddFileFromPhoto() {
        self.router?.dismissAddFilePopup(completion: {
            self.listener?.openFolderWantToAddFileFromPhoto(folderURL: self.viewModel.url)
        })
    }

    func addFilePopupWantToAddFileFromAudio() {
        self.router?.dismissAddFilePopup(completion: {
            self.listener?.openFolderWantToAddFileFromAudio(folderURL: self.viewModel.url)
        })
    }
}

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

    func addFilePopupWantToAddFileFromDocumentBrowser() {
        self.router?.dismissAddFilePopup(completion: {
            self.listener?.openFolderWantToAddFileFromDocumentBrowser(folderURL: self.viewModel.url)
        })
    }

    func addFilePopupWantToAddFileFromGoogleDrive() {
        self.router?.dismissAddFilePopup(completion: {
            self.listener?.openFolderWantToAddFileFromGoogleDrive(folderURL: self.viewModel.url)
        })
    }

    func addFilePopupWantToAddFileFromOneDrive() {
        self.router?.dismissAddFilePopup(completion: {
            self.listener?.openFolderWantToAddFileFromOnedrive(folderURL: self.viewModel.url)
        })
    }

    func addFilePopupWantToAddFileFromDropbox() {
        self.router?.dismissAddFilePopup(completion: {
            self.listener?.openFolderWantToAddFileFromDropbox(folderURL: self.viewModel.url)
        })
    }
}

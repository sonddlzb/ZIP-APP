//
//  HomeInteractor+OpenFolder.swift
//  Zip
//
//

import Foundation

extension HomeInteractor: OpenFolderListener {
    func openFolderWantToDismiss() {
        self.router?.dismissMyFile()
    }

    func openFolderWantToAddFileFromPhoto(folderURL: URL) {
        self.addFileFolderURL = folderURL
        self.router?.routeToSelectMedia()
    }

    func openFolderWantToAddFileFromAudio(folderURL: URL) {
        self.addFileFolderURL = folderURL
        self.router?.routeToSelectCategoryAudio()
    }

    func openFolderWantToAddFileFromDocumentBrowser(folderURL: URL) {
        self.addFileFolderURL = folderURL
        self.router?.showDocumentPicker()
    }

    func openFolderWantToAddFileFromGoogleDrive(folderURL: URL) {
        self.router?.routeToAddFileFromGoogleDrive(folderURL: folderURL)
    }

    func openFolderWantToAddFileFromOnedrive(folderURL: URL) {
        self.router?.routeToAddFileFromOneDrive(folderURL: folderURL)
    }

    func openFolderWantToAddFileFromDropbox(folderURL: URL) {
        self.router?.routeToAddFileFromDropbox(folderURL: folderURL)
    }

    func openFolderWantToExtract(zipURL: URL, outputFolderURL: URL) {
        self.router?.routeToExtract(zipURL: zipURL, outputFolderURL: outputFolderURL)
    }

    func openFolderWantToCompress(inputURLs: [URL], outputFolderURL: URL) {
        self.router?.routeToCompress(inputURLs: inputURLs, outputFolderURL: outputFolderURL)
    }
}

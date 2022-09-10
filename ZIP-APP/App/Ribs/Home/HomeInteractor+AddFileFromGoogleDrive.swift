//
//  HomeInteractor+AddFileFromGoogleDrive.swift
//  Zip
//
//

import Foundation

extension HomeInteractor: AddFileFromGoogleDriveListener {
    func addFileFromGoogleDriveWantToDismiss() {
        self.router?.dismissAddFileFromGoogleDrive()
    }

    func addFileFromGoogleDriveDidDownloadSuccessfully() {
        self.router?.resetMyFileScreen(highlightedItemURL: nil)
    }
}

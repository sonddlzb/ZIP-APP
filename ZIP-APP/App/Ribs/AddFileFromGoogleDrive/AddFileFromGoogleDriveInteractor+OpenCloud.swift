//
//  AddFileFromGoogleDriveInteractor+OpenCloud.swift
//  Zip
//
//

import Foundation
import GoogleSignIn

extension AddFileFromGoogleDriveInteractor: OpenCloudListener {
    func openCloudWantToDismiss() {
        self.router?.dismissOpenCloud()
        listener?.addFileFromGoogleDriveWantToDismiss()
    }

    func openCloudWantToLogout() {
        GIDSignIn.sharedInstance.signOut()
        self.router?.dismissOpenCloud()
        listener?.addFileFromGoogleDriveWantToDismiss()
    }

    func openCloudDidDownloadSuccessfully() {
        listener?.addFileFromGoogleDriveDidDownloadSuccessfully()
    }
}

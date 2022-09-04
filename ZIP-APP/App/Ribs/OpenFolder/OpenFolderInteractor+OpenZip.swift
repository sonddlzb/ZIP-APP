//
//  OpenFolderInteractor+OpenZip.swift
//  Zip
//
//

import Foundation

extension OpenFolderInteractor: OpenZipListener {
    func openZipWantToDismiss() {
        self.router?.dismissOpenZip(animated: true)
    }

    func openZipWantToExtract(url: URL) {
        listener?.openFolderWantToExtract(zipURL: url, outputFolderURL: url.deletingLastPathComponent())
    }
}

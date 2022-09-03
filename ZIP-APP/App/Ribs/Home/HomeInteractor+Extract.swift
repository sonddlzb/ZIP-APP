//
//  HomeInteractor+Extract.swift
//  Zip
//
//

import UIKit

extension HomeInteractor: ExtractListener {
    func extractWantToDismiss() {
        self.router?.dismissExtract()
    }

    func extractDidExtractingDone(zipFolderURL: URL) {
        self.router?.openFolder(url: zipFolderURL)
        self.router?.dismissExtract()
        self.router?.openFolderDismissOpenZip()
    }
}

//
//  HomeInteractor+Compress.swift
//  Zip
//
//

import Foundation
import QuartzCore

extension HomeInteractor: CompressListener {
    func compressWantToDismiss() {
        self.router?.dismissCompress()
    }

    func compressDidCompressDone(zipURL: URL) {
        self.router?.openFolderDismissOpenZip()
        self.router?.resetMyFileScreen(highlightedItemURL: zipURL)
        self.router?.routeToMyfileIfNeeded()

        self.router?.dismissSelectCategoryAudio(animated: false)
        self.router?.dismissSelectMedia(animated: false)
        self.router?.dismissCompress()
    }
}

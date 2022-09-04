//
//  OpenFolderInteractor+PreviewVideo.swift
//  Zip
//
//

import Foundation

extension OpenFolderInteractor: PreviewVideoListener {
    func previewVideoWantToDismiss() {
        self.router?.dismissPreviewVideo()
    }
}

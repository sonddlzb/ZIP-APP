//
//  OpenFolderInteractor+PreviewImage.swift
//  Zip
//
//

import Foundation

extension OpenFolderInteractor: PreviewImageListener {
    func previewImageWantToDismiss() {
        self.router?.dismissPreviewImage()
    }
}

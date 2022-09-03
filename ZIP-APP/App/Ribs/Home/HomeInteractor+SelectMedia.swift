//
//  HomeInteractor+SelectMedia.swift
//  Zip
//
//  Created by đào sơn on 03/09/2022.
//

import Foundation
import Photos

extension HomeInteractor: SelectMediaListener {
    func selectMediaWantToDismiss() {
        self.router?.dismissSelectMedia(animated: true)
    }

    func selectMediaWantToCompress(assets: [PHAsset]) {
        self.router?.routeToCompress(assets: assets, outputFolderURL: self.addFileFolderURL)
    }
}

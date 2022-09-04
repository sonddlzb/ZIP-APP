//
//  ExportAssetSession.swift
//  Zip
//
//

import UIKit
import Photos

class ExportAssetSession {
    private(set) var assets: [PHAsset]
    private var isExporting = false

    private lazy var exportAssetOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()

    init(assets: [PHAsset]) {
        self.assets = assets
    }

    func export(outputFolderURL: URL, completion: ((Error?) -> Void)? = nil) {
        if isExporting {
            return
        }

        DispatchQueue.global().async {
            self.isExporting = true
            let listOperations: [Operation] = self.assets.map { asset in
                ExportAssetOperation(asset: asset, outputFolderURL: outputFolderURL)
            }

            self.exportAssetOperationQueue.addOperations(listOperations, waitUntilFinished: true)
            let exportingError = listOperations.lazy.compactMap({
                ($0 as? ExportAssetOperation)?.error
            }).first
            self.isExporting = false
            completion?(exportingError)
        }
    }
}

//
//  OpenDriveItemViewModel.swift
//  Zip
//
//

import UIKit

struct OpenCloudItemViewModel {
    var item: CloudItem
    var isTopLineHidden: Bool

    func identifier() -> String {
        return item.identifier()
    }

    func name() -> String {
        return item.name()
    }

    func subtitle() -> String {
        let size = item.size()
        return size == 0 ? "" : size.memoryCapabilityDescription()
    }

    func isTopLineDisplaying() -> Bool {
        return !self.isTopLineHidden
    }

    func thumbailImage() -> UIImage {
        return item.thumbnail()
    }

    func isLoading() -> Bool {
        return item.isDownloading()
    }
}

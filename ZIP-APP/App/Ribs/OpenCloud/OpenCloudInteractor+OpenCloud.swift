//
//  OpenCloudInteractor+OpenCloud.swift
//  Zip
//
//

import Foundation

extension OpenCloudInteractor: OpenCloudListener {
    func openCloudDidDownloadSuccessfully() {
        listener?.openCloudDidDownloadSuccessfully()
    }

    func openCloudWantToDismiss() {
        self.router?.dismissOpenCloud()
    }

    func openCloudWantToLogout() {
        listener?.openCloudWantToLogout()
    }

    func openCloudDidSelectFolder(item: CloudItem) {
        self.router?.routeToOpenCloud(cloudItem: item, parentId: self.cloudItem.identifier(), cloudService: self.cloudService)
    }
}

//
//  OpenZipViewModel.swift
//  Zip
//
//

import Foundation

struct OpenZipViewModel {
    var url: URL
    private var info: [UZKFileInfo]

    init(url: URL) {
        self.url = url
        self.info = SSZipArchive.listFileInfo(url.path, error: nil)
    }

    func numberOfItems() -> Int {
        return info.count
    }

    func item(at index: Int) -> OpenZipItemViewModel {
        return OpenZipItemViewModel(item: info[index])
    }

    func name() -> String {
        return url.lastPathComponent
    }
}

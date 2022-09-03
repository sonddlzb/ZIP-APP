//
//  OpenZipItemViewModel.swift
//  Zip
//
//

import UIKit

struct OpenZipItemViewModel {
    var item: UZKFileInfo

    func name() -> String {
        return item.filename
    }

    func image() -> UIImage {
        if item.isDirectory {
            return UIImage(named: "ic_folder")!
        }

        if let pathExt = item.filename.components(separatedBy: ".").last?.lowercased() {
            return UIImage(named: "ic_extension_\(pathExt)") ?? UIImage(named: "ic_extension_unknown")!
        }

        return UIImage(named: "ic_extension_unknown")!
    }
}

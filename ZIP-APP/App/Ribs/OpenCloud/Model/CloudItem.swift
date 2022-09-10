//
//  CloudItem.swift
//  Zip
//
//

import UIKit

protocol CloudItem {
    func identifier() -> String
    func name() -> String
    func size() -> UInt64
    func fileExtension() -> String?
    func isDownloading() -> Bool
    func isFolder() -> Bool
}

extension CloudItem {
    func thumbnail() -> UIImage {
        return FileType.thumbnail(pathExt: self.fileExtension() ?? "unknown")
    }
}

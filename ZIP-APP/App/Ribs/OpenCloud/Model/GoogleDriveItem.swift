//
//  GoogleDriveItem.swift
//  Zip
//
//

import Foundation
import GoogleAPIClientForREST

struct GoogleDriveItem {
    var item: GTLRDrive_File?

    func mimeType() -> String? {
        return self.item?.mimeType
    }
}

extension GoogleDriveItem: CloudItem {
    func identifier() -> String {
        return item?.identifier ?? "root"
    }

    func name() -> String {
        return item?.name ?? "Google drive"
    }

    func size() -> UInt64 {
        return UInt64(item?.size?.int64Value ?? 0)
    }

    func fileExtension() -> String? {
        guard let mimeType = item?.mimeType else {
            return item?.fileExtension
        }

        return MimeType(mimeType).pathExtension()
    }

    func isDownloading() -> Bool {
        return GoogleDriveServiceInfo.current.isDownloading(itemId: self.identifier())
    }

    func isFolder() -> Bool {
        return item?.mimeType?.contains("folder") ?? false
    }
}

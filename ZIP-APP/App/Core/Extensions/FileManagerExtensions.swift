//
//  FileManagerExtensions.swift
//
//

import Foundation

public extension FileManager {
    static func documentPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
    }

    static func documentURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }

    static func cacheURL() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last!
    }

    static func myFileURL() -> URL {
        let url = self.documentURL().appendingPathComponent("My File")
        Self.createDirIfNeeded(path: url.path)
        return url
    }

    static func createDirIfNeeded(path: String) {
        var isDirectoryOutput: ObjCBool = false
        let pointer = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
        pointer.initialize(from: &isDirectoryOutput, count: 1)

        if FileManager.default.fileExists(atPath: path, isDirectory: pointer) == false || isDirectoryOutput.boolValue == false {
            try? FileManager.default.createDirectory(at: URL(fileURLWithPath: path), withIntermediateDirectories: true, attributes: nil)
        }
    }
}

extension FileManager {
    static func getValidURL(withName name: String, folderURL: URL, pathExt: String) -> URL {
        var currentName = name
        var index = 0
        while FileManager.default.fileExists(atPath: folderURL.appendingPathComponent(currentName).appendingPathExtension(pathExt).path) {
            index += 1
            currentName = "\(name)(\(index))"
        }

        return folderURL.appendingPathComponent(currentName).appendingPathExtension(pathExt)
    }
}

//
//  URLExtensions.swift
//
//

import Foundation

public extension URL {
    var params: [String: Any] {
        guard let query = self.query else { return [:] }
        let paramsComponent = query.components(separatedBy: "&")

        var paramsResult = [String: Any]()
        paramsComponent.forEach { (item) in
            let components = item.components(separatedBy: "=")
            let key = components[0]
            let value = components[1]

            paramsResult[key] = value
        }

        return paramsResult
    }

    var creationDate: Date? {
        return (try? resourceValues(forKeys: [.creationDateKey]))?.creationDate
    }

    func fileExtension() -> String {
        let lastPathComponent = self.lastPathComponent
        let components = lastPathComponent.components(separatedBy: ".")
        if components.isEmpty {
            return ""
        }

        return components.last!
    }

    func randomFileNameWithSameExtension() -> String {
        let fileExt = self.fileExtension()
        let randomName = "\(UUID().uuidString)"
        return "\(randomName).\(fileExt)"
    }

    func resourceUri() -> String {
        let userPath = FileManager.documentPath()
        return self.path.replacingOccurrences(of: userPath, with: "")
    }

    init(resourceUri: String) {
        let userPath = FileManager.documentPath()
        let fullPath = "\(userPath)\(resourceUri)"
        self.init(fileURLWithPath: fullPath)
    }
}

extension URL {
    func size() -> Int64 {
        if let attribute = try? FileManager.default.attributesOfItem(atPath: self.path),
           let fileSize = attribute[.size] as? Int64 {
            return fileSize
        }

        return 0
    }

    /// check if the URL is a directory and if it is reachable
    func isDirectoryAndReachable() throws -> Bool {
        if let isDirectory = try resourceValues(forKeys: [.isDirectoryKey]).isDirectory {
            return try checkResourceIsReachable() && isDirectory
        } else {
            return false
        }
    }

    func directoryTotalAllocatedSize() throws -> Double? {
        guard try isDirectoryAndReachable() else {
            return nil
        }

        var totalFileSize = 0.0
        let enumerator = FileManager.default.enumerator(at: self, includingPropertiesForKeys: nil)!
        while let url = enumerator.nextObject() as? URL {
            totalFileSize += Double(try url.resourceValues(forKeys: [.totalFileAllocatedSizeKey]).totalFileAllocatedSize ?? 0)
            print(totalFileSize)
        }

        return totalFileSize
    }

    func directoryTotalAllocatedSize(forFileType fileType: FileType) throws -> Double? {
        guard try isDirectoryAndReachable() else {
            return nil
        }

        var totalFileTypeSize = 0.0
        let enumerator = FileManager.default.enumerator(at: self, includingPropertiesForKeys: nil)!
        while let url = enumerator.nextObject() as? URL {
            if FileType.make(extensionPath: url.pathExtension) == fileType {
                totalFileTypeSize += Double(try url.resourceValues(forKeys: [.totalFileAllocatedSizeKey]).totalFileAllocatedSize ?? 0)
            }
        }

        return totalFileTypeSize
    }

    func totalSizeOnDiskForAllFiles() throws -> Double? {
        guard let size = try directoryTotalAllocatedSize() else {
            return nil
        }

        return Double(size)
    }

    func totalSizeOnDiskForPhotos() throws -> Double? {
        guard let size = try directoryTotalAllocatedSize(forFileType: .image) else {
            return nil
        }

        return size
    }

    func totalSizeOnDiskForAudios() throws -> Double? {
        guard let size = try directoryTotalAllocatedSize(forFileType: .audio) else {
            return nil
        }

        return size
    }
}


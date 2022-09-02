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


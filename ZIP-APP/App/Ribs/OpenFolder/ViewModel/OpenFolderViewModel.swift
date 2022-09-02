//
//  OpenFolderViewModel.swift
//  Zip
//
//

import UIKit

struct OpenFolderViewModel {
    var url: URL
    var selectedURLs: [URL]
    var isSelectingModeEnabled: Bool

    init(url: URL, isSelectingModeEnabled: Bool = false) {
        self.url = url
        self.selectedURLs = []
        self.isSelectingModeEnabled = isSelectingModeEnabled
    }

    // MARK: - Getter
    func isEmpty() -> Bool {
        return (try? FileManager.default.contentsOfDirectory(atPath: url.path).isEmpty) ?? true
    }

    func name() -> String {
        return self.url.lastPathComponent
    }

    func isMyFile() -> Bool {
        return self.url == FileManager.myFileURL()
    }

    func isSelectedModeOn() -> Bool {
        return self.isSelectingModeEnabled
    }

    func isOptionViewVisible() -> Bool {
        return self.isSelectingModeEnabled && self.numberOfSelectedItems() > 0
    }

    func title() -> String {
        return self.isSelectedModeOn() ? "Selected (\(self.selectedURLs.count))" : self.name()
    }

    func titleAlignment() -> NSTextAlignment {
        return self.isSelectedModeOn() || !self.isMyFile() ? .left : .center
    }

    func numberOfItems() -> Int {
        return (try? FileManager.default.contentsOfDirectory(atPath: self.url.path).count) ?? 0
    }

    func numberOfSelectedItems() -> Int {
        return self.selectedURLs.count
    }

    func isSelectedAll() -> Bool {
        return self.numberOfSelectedItems() == self.numberOfItems()
    }

    func isSelectedItemsEmpty() -> Bool {
        return self.selectedURLs.isEmpty
    }

    func contents() -> [URL] {
        let contents = (try? FileManager.default.contentsOfDirectory(atPath: self.url.path)) ?? []
        return contents.map({ url.appendingPathComponent($0) })
    }

    func selectAllImage() -> UIImage {
        return UIImage(named: self.self.selectedURLs.count == self.numberOfItems() ? "rd_unselected" : "rd_selected")!
    }

    func backButtonImage() -> UIImage {
        return UIImage(named: self.isSelectingModeEnabled ? "ic_close" : "ic_back")!
    }

    func getOptions() -> [OptionActionType] {
        var result = [OptionActionType]()
        if selectedURLs.count == 1 && FileType.make(extensionPath: selectedURLs.first!.pathExtension) == .zip {
            result.append(.extract)
        }

        result.append(.compress)
        result.append(.move)
        result.append(.more)

        if selectedURLs.count == 1 {
            result.append(.rename)
        }

        result.append(.share)
        result.append(.delete)
        return result
    }

    func titleDeleteDialog() -> String {
        return "Delete Items"
    }

    func messageDeleteDialog() -> String {
        return "Are you sure you want to delete the \(self.numberOfSelectedItems()) selected item\(self.numberOfSelectedItems() > 1 ? "s" : "")"
    }

    // MARK: - Interactor
    mutating func popLastComponent() -> Bool {
        if self.isMyFile() {
            return false
        }

        self.url = self.url.deletingLastPathComponent()
        return true
    }

    mutating func selectAll() {
        self.selectedURLs = self.contents()
        self.isSelectingModeEnabled = true
    }

    mutating func unselectAll() {
        self.selectedURLs = []
    }

    mutating func rename(fromURL source: URL, toURL destination: URL) {
        if self.selectedURLs.contains(source) {
            self.selectedURLs.removeObject(source)
            self.selectedURLs.append(destination)
        }
    }
}

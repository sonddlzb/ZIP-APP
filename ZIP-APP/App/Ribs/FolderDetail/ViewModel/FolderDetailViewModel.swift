//
//  FolderDetailViewModel.swift
//  Zip
//
//

import UIKit

struct FolderDetailViewModel {
    var url: URL
    var isOnlyFolderDisplayed: Bool
    var exceptedURLs: [String: Bool]
    var contentOffsetManager: [String: CGFloat]
    private var contents: [String]
    private var isPathSelected: [String: Bool]
    var inOnSelectedMode = false

    init(url: URL, isOnlyFolderDisplayed: Bool, exceptedURLs: [URL], contentOffsetManager: [String: CGFloat] = [:]) {
        self.url = url
        self.isOnlyFolderDisplayed = isOnlyFolderDisplayed
        self.exceptedURLs = [:]
        self.isPathSelected = [:]
        self.contents = []
        self.contentOffsetManager = contentOffsetManager
        exceptedURLs.forEach({ self.exceptedURLs[$0.path] = true })
    }

    // MARK: - Getter
    func numberOfItems() -> Int {
        return self.contents.count
    }

    func item(at index: Int) -> FolderDetailItemViewModel {
        let contentURL = url.appendingPathComponent(self.contents[index])
        return FolderDetailItemViewModel(url: contentURL,
                                         isSelected: self.isPathSelected[contentURL.path] ?? false)
    }

    func selectedURLs() -> [URL] {
        return isPathSelected.filter({ $0.value }).compactMap({ URL(fileURLWithPath: $0.key) })
    }

    func isItemSelected(_ itemViewModel: FolderDetailItemViewModel) -> Bool {
        return isPathSelected[itemViewModel.url.path] ?? false
    }

    func listItemViewModels() -> [FolderDetailItemViewModel] {
        return self.contents.map { element in
            let contentURL = url.appendingPathComponent(element)
            return FolderDetailItemViewModel(url: contentURL,
                                             isSelected: self.isPathSelected[contentURL.path] ?? false)
        }
    }

    func currentContentOffsetY() -> CGFloat? {
        return self.contentOffsetManager[self.url.path]
    }

    func index(url: URL) -> Int? {
        guard self.url == url.deletingLastPathComponent() else {
            return nil
        }

        return self.contents.firstIndex(of: url.lastPathComponent)
    }

    // MARK: - Interactor
    mutating func select(itemViewModel: FolderDetailItemViewModel) {
        isPathSelected[itemViewModel.url.path] = true
        self.inOnSelectedMode = true
    }

    mutating func unselect(itemViewModel: FolderDetailItemViewModel) {
        isPathSelected[itemViewModel.url.path] = false
    }

    mutating func selectAll() {
        self.isPathSelected = [:]
        self.contents.forEach({ self.isPathSelected[url.appendingPathComponent($0).path] = true })
        self.inOnSelectedMode = true

    }

    mutating func unselectAll() {
        self.isPathSelected = [:]
    }

    mutating func turnOffSelectedMode() {
        self.inOnSelectedMode = false
    }

    mutating func move(fromURL: URL, toURL: URL) {
        if self.isPathSelected[fromURL.path] ?? false {
            self.isPathSelected[fromURL.path] = false
            self.isPathSelected[toURL.path] = true
            self.refreshContents()
        }
    }

    mutating func refreshContents() {
        var newContents = [String]()
        let listContents = (try? FileManager.default.contentsOfDirectory(atPath: url.path)) ?? []

        newContents.append(contentsOf: listContents.filter({
            self.isFolder(name: $0) &&
            self.exceptedURLs[self.url.appendingPathComponent($0).path] != true
        }).sorted(by: compareToSortListContents(lhs:rhs:)))

        if !isOnlyFolderDisplayed {
            newContents.append(contentsOf: listContents.filter({
                self.isZip(name: $0) &&
                self.exceptedURLs[self.url.appendingPathComponent($0).path] != true
            }).sorted(by: compareToSortListContents(lhs:rhs:)))

            newContents.append(contentsOf: listContents.filter({
                !self.isFolder(name: $0) &&
                !self.isZip(name: $0) &&
                self.exceptedURLs[self.url.appendingPathComponent($0).path] != true
            }).sorted(by: compareToSortListContents(lhs:rhs:)))
        }

        self.contents = newContents
    }

    mutating func save(url: URL, contentOffsetY: CGFloat) {
        self.contentOffsetManager[url.path] = contentOffsetY
    }

    // MARK: - Helper
    func isFolder(name: String) -> Bool {
        return FileType.make(extensionPath: self.url.appendingPathComponent(name).pathExtension) == .folder
    }

    func isZip(name: String) -> Bool {
        return FileType.make(extensionPath: self.url.appendingPathComponent(name).pathExtension) == .zip
    }

    private func compareToSortListContents(lhs: String, rhs: String) -> Bool {
        let lDate = url.appendingPathComponent(lhs).creationDate ?? Date()
        let rDate = url.appendingPathComponent(rhs).creationDate ?? Date()
        if lDate == rDate {
            return lhs.lowercased().compare(rhs.lowercased()) == .orderedAscending
        } else {
            return (lDate).compare(rDate)  == .orderedDescending
        }
    }
}

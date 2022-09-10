//
//  OpenDriveViewModel.swift
//  Zip
//
//

import UIKit

struct OpenCloudViewModel {
    var id: String
    var parentId: String?
    var listFolders: [CloudItem] = []
    var listFiles: [CloudItem] = []
    var service: CloudService

    func numberOfSections() -> Int {
        return 2
    }

    func numberOfItems(in section: Int) -> Int {
        return section == 0 ? listFolders.count : listFiles.count
    }

    func item(at index: Int, section: Int) -> OpenCloudItemViewModel {
        return OpenCloudItemViewModel(item: section == 0 ? listFolders[index] : listFiles[index],
                                      isTopLineHidden: index != 0 || isEmpty(section: 0))
    }

    func folderName() -> String {
        return service.folderName(id: self.id) ?? "Unknown"
    }

    func parentFolderName() -> String {
        if let parentId = parentId,
           let name = service.folderName(id: parentId) {
            return name
        }

        return "Select"
    }

    func contentInset(for section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: isEmpty(section: 0) ? 0 : 12,
                                left: 0,
                                bottom: isEmpty(section: 0) ? 0 : 15,
                                right: 0)
        }

        return .zero
    }

    func isEmpty(section: Int) -> Bool {
        return (section == 0 && listFolders.isEmpty) || (section == 1 && listFiles.isEmpty)
    }

    func isContain(item: CloudItem) -> Bool {
        return self.listFiles.contains(where: { item.identifier() == $0.identifier() }) || self.listFolders.contains(where: { item.identifier() == $0.identifier() })
    }

    mutating func replace(items: [CloudItem]) {
        self.listFiles = []
        self.listFolders = []
        items.forEach { item in
            if item.isFolder() {
                self.listFolders.append(item)
            } else {
                self.listFiles.append(item)
            }
        }
    }
}

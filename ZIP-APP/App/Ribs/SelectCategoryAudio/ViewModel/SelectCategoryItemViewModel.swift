//
//  SelectCategoryItemViewModel.swift
//  Zip
//
//

import Foundation
import MediaPlayer

struct SelectCategoryItemViewModel: FolderDetailCellViewModel {
    var category: MPMediaItemCollection

    func id() -> String {
        return String(category.persistentID)
    }

    func name() -> String {
        if let name = category.representativeItem?.value(forProperty: MPMediaItemPropertyArtist) as? String, !name.trim().isEmpty {
            return name.trim()
        }

        return "New folder"
    }

    func thumbnail() -> UIImage {
        FileType.folderThumbnail(numberOfSubitems: category.count)
    }

    func contentModeThumbnail() -> UIView.ContentMode {
        return .scaleAspectFit
    }

    func needHidePlayImageView() -> Bool {
        return true
    }

    func shadowThumbnailOpacity() -> Float {
        return 0
    }

    func borderWidthThumbnail() -> CGFloat {
        return 0
    }

    func backgroundColor() -> UIColor {
        return .clear
    }

    func type() -> FileType {
        return .folder
    }

    func isCellSelected() -> Bool {
        return false
    }
}

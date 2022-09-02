//
//  FolderDetailCellViewModel.swift
//  Zip
//
//

import UIKit

protocol FolderDetailCellViewModel {
    func id() -> String
    func name() -> String
    func thumbnail() -> UIImage
    func contentModeThumbnail() -> UIView.ContentMode
    func needHidePlayImageView() -> Bool
    func shadowThumbnailOpacity() -> Float
    func borderWidthThumbnail() -> CGFloat
    func backgroundColor() -> UIColor
    func type() -> FileType
    func isCellSelected() -> Bool
}

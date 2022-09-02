//
//  FolderDetailItemViewModel.swift
//  Zip
//
//

import AVFoundation
import UIKit
import DifferenceKit

struct FolderDetailItemViewModel: FolderDetailCellViewModel {
    var url: URL
    var isSelected: Bool

    func id() -> String {
        return url.path
    }

    func name() -> String {
        return self.url.lastPathComponent
    }

    func thumbnail() -> UIImage {
        return self.type().thumbnail(url: url)
    }

    func contentModeThumbnail() -> UIView.ContentMode {
        return self.type() == .image || self.type() == .video ? .scaleAspectFill : .scaleAspectFit
    }

    func needHidePlayImageView() -> Bool {
        return self.type() != .video
    }

    func shadowThumbnailOpacity() -> Float {
        return self.type() == .image || self.type() == .video ? 0.1 : 0
    }

    func borderWidthThumbnail() -> CGFloat {
        return self.type() == .image || self.type() == .video ? 1 : 0
    }

    func backgroundColor() -> UIColor {
        return isSelected ? UIColor(rgb: 0xE8F2FF) : .white
    }

    func type() -> FileType {
        return .make(extensionPath: self.url.pathExtension)
    }

    func isCellSelected() -> Bool {
        return isSelected
    }
}

extension FolderDetailItemViewModel: Differentiable, Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(url.absoluteString)
    }

    static func == (lhs: FolderDetailItemViewModel, rhs: FolderDetailItemViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

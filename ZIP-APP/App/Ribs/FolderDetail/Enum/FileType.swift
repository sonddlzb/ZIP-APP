//
//  FileType.swift
//  Zip
//
//

import UIKit
import AVFoundation

enum FileType {
    case video
    case audio
    case image
    case zip
    case folder
    case unknown

    static func make(extensionPath: String) -> FileType {
        let extensionPathUpper = extensionPath.uppercased()
        return [FileType.image,
                FileType.video,
                FileType.audio,
                FileType.zip,
                FileType.folder]
            .first(where: { $0.extensionPath().contains(extensionPathUpper) }) ?? .unknown
    }

    func extensionPath() -> [String] {
        switch self {
        case .video:
            return ["MP4", "MOV", "3GP", "AVI", "FLV", "M4V", "MPG", "WMV"]
        case .audio:
            return ["MP3", "M4A", "WAV", "AAC", "OGG", "AIF", "M3U", "RA"]
        case .image:
            return ["JPG", "GIF", "PNG", "BMP", "TTF", "TGA", "ICO", "PSD", "RAW", "CUR"]
        case .zip:
            return ["ZIP"]
        case .folder:
            return [""]
        default:
            return []
        }
    }

    func thumbnail(url: URL) -> UIImage {
        if self == .folder {
            let numberOfItems = (try? FileManager.default.contentsOfDirectory(atPath: url.path).count) ?? 0
            return UIImage(named: numberOfItems > 0 ? "ic_folder" : "ic_folder_empty")!
        }

        if self == .image,
           let image = UIImage(contentsOfFile: url.path)?.resizeToFit(maxSize: 600) {
            return image
        }

        if self == .video {
            let asset = AVAsset(url: url)
            if let thumbnail = asset.thumbnailImage {
                return thumbnail
            }
        }

        let pathExt = url.pathExtension.lowercased()
        return UIImage(named: "ic_extension_\(pathExt)") ?? UIImage(named: "ic_extension_unknown")!
    }

    static func folderThumbnail(numberOfSubitems: Int) -> UIImage {
        return UIImage(named: numberOfSubitems > 0 ? "ic_folder" : "ic_folder_empty")!
    }

    static func thumbnail(pathExt: String) -> UIImage {
        if pathExt.isEmpty {
            return UIImage(named: "ic_folder_empty")!
        }

        return UIImage(named: "ic_extension_\(pathExt.lowercased())") ?? UIImage(named: "ic_extension_unknown")!
    }
}

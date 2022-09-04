//
//  CompressInputValue.swift
//  Zip
//
//

import UIKit
import Photos
import MediaPlayer

enum CompressInputValue {
    case urls([URL])
    case audios([MPMediaItem])
    case assets([PHAsset])

    func totalSize() -> UInt64 {
        switch self {
        case .urls(let array):
            return array.map { url in
                return UInt64(url.size())
            }.reduce(0, +)

        case .audios(let array):
            return array.map { audio in
                guard let assetURL = audio.value(forProperty: MPMediaItemPropertyAssetURL) as? URL else {
                    return UInt64(0)
                }

                return UInt64(assetURL.size())
            }.reduce(0, +)

        case .assets(let array):
            return array.map { asset in
                return asset.fileSize()
            }.reduce(0, +)
        }
    }
}

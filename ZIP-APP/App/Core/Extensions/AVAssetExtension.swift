//
//  AVAssetExtension.swift
//
//

import AVFoundation
import UIKit

public extension AVAsset {
    var thumbnailImage: UIImage? {
        let imgGenerator = AVAssetImageGenerator(asset: self)
        guard let cgImage = try? imgGenerator.copyCGImage(at: .zero, actualTime: nil) else {
            return nil
        }

        var image = UIImage()
        image = UIImage(cgImage: cgImage, scale: 1, orientation: image.imageOrientation)
        let ratio = image.size.width / image.size.height
        let size = ratio > 1 ? CGSize(width: 800, height: 800/ratio) : CGSize(width: 800*ratio, height: 800)
        image = image.resize(to: size)

        return image
    }

    func resolution() -> CGSize {
        guard let videoTrack = self.tracks(withMediaType: .video).first else {
            return .zero
        }

        let orientation = self.videoOrientation
        if orientation == .left || orientation == .right || orientation == .leftMirrored || orientation == .rightMirrored {
            return CGSize(width: videoTrack.naturalSize.height, height: videoTrack.naturalSize.width)
        }

        return videoTrack.naturalSize
    }

    var videoOrientation: UIImage.Orientation {
        guard let videoTrack = self.tracks(withMediaType: .video).first else {
            return .up
        }

        let transform = videoTrack.preferredTransform
        let videoAngleInDegree = radiansToDegrees(atan2(transform.b, transform.a))
        let scaleX = (transform.a/abs(transform.a)) * sqrt(pow(transform.a, 2) + pow(transform.c, 2))
        // let scaleY = (transform.d/abs(transform.d)) * sqrt(pow(transform.b, 2) + pow(transform.d, 2))

        var orientation = UIImage.Orientation.up
        switch videoAngleInDegree {
            case 0:
                orientation = .up
            case 90:
                orientation = .right
            case 180:
                orientation = .down
            case -90:
                orientation = .left
            default:
                break
        }

        if scaleX == -1 {
        switch orientation {
            case .up:
                return .upMirrored
            case .down:
                return .downMirrored
            default:
                break
            }
        }

        return orientation
    }

    private func radiansToDegrees(_ value: CGFloat) -> CGFloat {
        return value * 180 / CGFloat.pi
    }
}

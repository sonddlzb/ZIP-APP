//
//  PreviewVideoViewModel.swift
//  Zip
//
//  Created by đào sơn on 08/07/2022.
//

import Foundation
import Photos
import RxSwift
import UIKit

struct PreviewVideoViewModel {
    var asset: PHAsset?
    var videoURL: URL?
    var disposeBag = DisposeBag()
    var currentVideoTime: TimeInterval = 0.0

    private var cachedDuration: TimeInterval?

    init(asset: PHAsset?, videoURL: URL?) {
        self.asset = asset
        self.videoURL = videoURL
        self.currentVideoTime = 0
    }

    func fetchAVAsset(completion: @escaping ((_ avAsset: AVAsset?) -> Void)) {
        if let videoURL = videoURL {
            completion(AVAsset(url: videoURL))
            return
        }

        asset?.fetchAVAsset().subscribe(onNext: completion).disposed(by: disposeBag)
    }

    func formatTime(time: Double) -> String {
        var res: String
        let interval = Int(time)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        res = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        var offset = -1 * res.count
        if interval < 600 {
            offset = -4
        } else if interval < 3600 {
            offset = -5
        } else if interval < 36000 {
            offset = -7
        }

        let index = res.index(res.endIndex, offsetBy: offset)
        res = String(res.suffix(from: index))
        return res
    }

    mutating func durationString() -> String {
        self.formatTime(time: self.duration())
    }

    func currentTimeLabelValue() -> String {
        return self.formatTime(time: currentVideoTime)
    }

    mutating func seekBarProgressValue() -> Double {
        return self.currentVideoTime/self.duration()
    }

    private mutating func duration() -> TimeInterval {
        if self.cachedDuration == nil {
            if let videoURL = videoURL {
                self.cachedDuration = AVAsset(url: videoURL).duration.seconds
            } else {
                self.cachedDuration = asset?.duration
            }
        }

        return self.cachedDuration ?? 0
    }
}

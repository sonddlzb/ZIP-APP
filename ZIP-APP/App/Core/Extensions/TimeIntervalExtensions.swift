//
//  TimeIntervalExtensions.swift
//
//

import Foundation
import AVFoundation

public extension TimeInterval {
    func toDurationString() -> String {
        let seconds: Int = Int(self.rounded()) % 60
        let minutes = Int(self.rounded() / 60)
        return String.init(format: "%02d:%02d", minutes, seconds)
    }

    func cgFloat() -> CGFloat {
        return CGFloat(self)
    }
}

public extension CMTime {
    func toDouble() -> Float64 {
        return CMTimeGetSeconds(self)
    }
}

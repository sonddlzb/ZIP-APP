//
//  AVAudioPlayerNodeExtensions.swift
//
//

import Foundation
import AVFoundation

public extension AVAudioPlayerNode {
    var currentTime: TimeInterval {
        if let nodeTime = lastRenderTime, let playerTime = playerTime(forNodeTime: nodeTime) {
            return Double(playerTime.sampleTime) / playerTime.sampleRate
        }

        return 0
    }
}

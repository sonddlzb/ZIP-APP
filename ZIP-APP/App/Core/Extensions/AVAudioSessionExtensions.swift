//
//  AVAudioSessionExtensions.swift
//  CoreUtils
//
//

import Foundation
import AVFoundation

public extension AVAudioSession {
    static func active(category: Category = .playback) {
        try? AVAudioSession.sharedInstance().setCategory(category)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
}

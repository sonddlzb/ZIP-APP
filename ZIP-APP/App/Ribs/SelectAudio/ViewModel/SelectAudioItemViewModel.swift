//
//  SelectAudioItemViewModel.swift
//  Zip
//
//

import Foundation
import MediaPlayer
import DifferenceKit

struct SelectAudioItemViewModel {
    var audioItem: MPMediaItem
    var isSelected: Bool
    var isPlaying: Bool

    func imageForSelectButton() -> UIImage {
        return UIImage(named: isSelected ? "ic_checked" : "ic_unchecked")!
    }

    func imageForPlayButton() -> UIImage {
        return UIImage(named: isPlaying ? "ic_pause_dark" : "ic_play_dark")!
    }

    func title() -> String {
        return audioItem.title ?? "Unknown"
    }

    func durationString() -> String {
        return audioItem.playbackDuration.toDurationString()
    }
}

extension SelectAudioItemViewModel: Differentiable, Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(audioItem.persistentID)
        hasher.combine(isPlaying)
    }

    static func == (lhs: SelectAudioItemViewModel, rhs: SelectAudioItemViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

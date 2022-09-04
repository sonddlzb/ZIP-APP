//
//  SelectCategoryAudioInteractor+SelectAudio.swift
//  Zip
//
//

import Foundation
import MediaPlayer

extension SelectCategoryAudioInteractor: SelectAudioListener {
    func selectAudioWantToDismiss() {
        self.router?.dismissSelectAudio()
    }

    func selectAudioWantToCompress(audios: [MPMediaItem]) {
        listener?.selectCategoryAudioWantToCompress(audios: audios)
    }
}

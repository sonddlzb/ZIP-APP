//
//  HomeInteractor+SelectCategoryAudio.swift
//  Zip
//
//

import Foundation
import MediaPlayer

extension HomeInteractor: SelectCategoryAudioListener {
    func selectCategoryAudioWantToCompress(audios: [MPMediaItem]) {
        self.router?.routeToCompress(audios: audios, outputFolderURL: self.addFileFolderURL)
    }

    func selectCategoryAudioWantToDismiss() {
        self.router?.dismissSelectCategoryAudio(animated: true)
    }
}

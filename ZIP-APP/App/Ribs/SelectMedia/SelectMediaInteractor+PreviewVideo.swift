//
//  SelectMediaInteractor+PreviewVideo.swift
//  Zip
//
//  Created by đào sơn on 03/09/2022.
//

import Foundation

extension SelectMediaInteractor: PreviewVideoListener {
    func previewVideoWantToDismiss() {
        router?.dismissPreviewVideo()
    }
}

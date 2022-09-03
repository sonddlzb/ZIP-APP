//
//  SelectMediaInteractor+PreviewImage.swift
//  Zip
//
//  Created by đào sơn on 03/09/2022.
//

import Foundation

extension SelectMediaInteractor: PreviewImageListener {
    func previewImageWantToDismiss() {
        router?.dismissPreviewImage()
    }
}

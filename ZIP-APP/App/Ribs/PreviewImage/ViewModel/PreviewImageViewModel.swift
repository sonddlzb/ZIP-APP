//
//  PreviewImageViewModel.swift
//  Zip
//
//  Created by đào sơn on 06/07/2022.
//

import Foundation
import Photos
import UIKit
import RxSwift

struct PreviewImageViewModel {
    var asset: PHAsset?
    var imageURL: URL?
    var disposeBag = DisposeBag()

    func fetchImage(completion: @escaping ((_ image: UIImage?) -> Void)) {
        if let asset = asset {
            asset.fetchImage().subscribe(onNext: { image in
                completion(image)
            }).disposed(by: disposeBag)
        } else if let url = imageURL {
            completion(UIImage(contentsOfFile: url.path))
        }
    }
}

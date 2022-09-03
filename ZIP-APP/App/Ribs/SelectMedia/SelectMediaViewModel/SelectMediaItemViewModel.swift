//
//  SelectMediaViewModelItem.swift
//  Zip
//
//  Created by đào sơn on 20/06/2022.
//

import Photos
import UIKit

import DifferenceKit
import RxSwift

struct SelectMediaItemViewModel {
    var asset: PHAsset
    var isSelected: Bool

    func fetchThumbnail(completion: @escaping ((_ image: UIImage?) -> Void)) {
        DispatchQueue.global().async {
            let thumbnail = self.asset.thumbnail(size: CGSize(width: 500, height: 500))
            DispatchQueue.main.async {
                completion(thumbnail)
            }
        }
    }
}

extension SelectMediaItemViewModel: Differentiable, Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(asset.localIdentifier)
    }

    static func == (lhs: SelectMediaItemViewModel, rhs: SelectMediaItemViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

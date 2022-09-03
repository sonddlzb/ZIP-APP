//
//  OpenZipCell.swift
//  Zip
//
//

import UIKit

class OpenZipCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!

    func bind(itemViewModel: OpenZipItemViewModel) {
        titleLabel.text = itemViewModel.name()
        thumbnailImageView.image = itemViewModel.image()
    }
}

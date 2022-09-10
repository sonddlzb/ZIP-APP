//
//  DriveFolderCell.swift
//  Zip
//
//

import UIKit

class CloudFolderCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel!

    func bind(viewModel: OpenCloudItemViewModel) {
        self.titleLabel.text = viewModel.name()
    }
}

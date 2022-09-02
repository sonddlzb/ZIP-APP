//
//  FolderDetailCell.swift
//  Zip
//
//

import UIKit

final class FolderDetailCell: UICollectionViewCell {

    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var checkedImageView: UIImageView!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var playImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    var viewModel: FolderDetailCellViewModel!

    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbnailImageView.image = nil
    }

    func bind(itemViewModel: FolderDetailCellViewModel) {
        self.viewModel = itemViewModel
        self.bindSelectedState(itemViewModel: itemViewModel)
        self.titleLabel.text = itemViewModel.name()

        self.playImageView.isHidden = itemViewModel.needHidePlayImageView()
        self.shadowView.shadowOpacity = itemViewModel.shadowThumbnailOpacity()
        self.thumbnailImageView.borderWidth = itemViewModel.borderWidthThumbnail()
        self.thumbnailImageView.contentMode = itemViewModel.contentModeThumbnail()

        DispatchQueue.global().async {
            let thumbnail = itemViewModel.thumbnail()
            DispatchQueue.main.async { [weak self] in
                if itemViewModel.id() == self?.viewModel.id() {
                    self?.thumbnailImageView.image = thumbnail
                }
            }
        }
    }

    func bindSelectedState(itemViewModel: FolderDetailCellViewModel) {
        self.checkedImageView.isHidden = !itemViewModel.isCellSelected()
        self.containerView.backgroundColor = itemViewModel.backgroundColor()
    }

    func highlight() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.containerView.transform = .init(scaleX: 0.7, y: 0.7)
                self.containerView.alpha = 0.5
            }

            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1) {
                self.containerView.transform = .identity
                self.containerView.alpha = 1
            }
        }
    }
}

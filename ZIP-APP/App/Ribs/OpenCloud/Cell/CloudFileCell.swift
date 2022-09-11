//
//  DriveFileCell.swift
//  Zip
//
//

import UIKit

class CloudFileCell: UICollectionViewCell {

    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var playImageView: UIImageView!
    @IBOutlet private weak var topLineView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    var viewModel: OpenCloudItemViewModel?

    // MARK: - Override function
    override func awakeFromNib() {
        super.awakeFromNib()
        indicatorView.hidesWhenStopped = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel = nil
    }

    // MARK: - Binding
    func bind(viewModel: OpenCloudItemViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.name()
        subtitleLabel.text = viewModel.subtitle()
        topLineView.isHidden = !viewModel.isTopLineDisplaying()
        self.thumbnailImageView.image = viewModel.thumbailImage()
        if viewModel.isLoading() {
            indicatorView.startAnimating()
        } else {
            indicatorView.stopAnimating()
        }
    }
}

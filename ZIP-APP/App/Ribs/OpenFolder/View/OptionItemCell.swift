//
//  OptionItemCell.swift
//  Zip
//
//

import UIKit

protocol OptionItemCellDelegate: AnyObject {
    func optionItemCellDidSelected(_ cell: OptionItemCell)
}

class OptionItemCell: UICollectionViewCell {

    @IBOutlet private weak var horizontalContentView: UIView!
    @IBOutlet private weak var verticalContentView: UIView!
    @IBOutlet private weak var iconVerticalImageView: UIImageView!
    @IBOutlet private weak var titleVerticalLabel: UILabel!
    @IBOutlet private weak var iconHorizontalImageView: UIImageView!
    @IBOutlet private weak var titleHorizontalLabel: UILabel!

    weak var delegate: OptionItemCellDelegate?
    var viewModel: OptionItemViewModel!

    func bind(viewModel: OptionItemViewModel) {
        self.viewModel = viewModel

        self.verticalContentView.isHidden = viewModel.isHorizontal
        self.horizontalContentView.isHidden = !self.verticalContentView.isHidden

        self.titleVerticalLabel.text = viewModel.description()
        self.titleHorizontalLabel.text = viewModel.description()
        self.iconVerticalImageView.image = viewModel.image()
        self.iconHorizontalImageView.image = viewModel.image()
    }

    @IBAction func optionItemDidTap(_ sender: Any) {
        delegate?.optionItemCellDidSelected(self)
    }
}

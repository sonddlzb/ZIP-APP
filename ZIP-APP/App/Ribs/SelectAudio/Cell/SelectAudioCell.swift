//
//  SelectAudioCell.swift
//  Zip
//
//

import UIKit

protocol SelectAudioCellDelegate: AnyObject {
    func selectAudioCellDidSelect(_ cell: SelectAudioCell)
    func selectAudioCell(_ cell: SelectAudioCell, didChangePlayerStatus isPlaying: Bool)
}

class SelectAudioCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var scrollableLabel: ScrollableLabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var titleStaticLabel: UILabel!
    @IBOutlet private weak var selectButton: UIButton!
    @IBOutlet private weak var playButton: UIButton!

    weak var delegate: SelectAudioCellDelegate?
    var viewModel: SelectAudioItemViewModel!

    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.titleStaticLabel.isHidden = false
        self.scrollableLabel.isHidden = !self.titleStaticLabel.isHidden
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.scrollableLabel.stopAnimation()
        self.titleStaticLabel.isHidden = false
        self.scrollableLabel.isHidden = !self.titleStaticLabel.isHidden
    }

    // MARK: - Action
    @IBAction func playButtonDidTap(_ sender: Any) {
        delegate?.selectAudioCell(self, didChangePlayerStatus: !viewModel.isPlaying)
    }

    @IBAction func selectButtonDidTap(_ sender: Any) {
        delegate?.selectAudioCellDidSelect(self)
    }

    // MARK: - Method
    func bind(viewModel: SelectAudioItemViewModel) {
        self.viewModel = viewModel
        UIView.performWithoutAnimation {
            self.scrollableLabel.text = viewModel.title()
            self.titleStaticLabel.text = viewModel.title()
            self.titleStaticLabel.sizeToFit()
            self.durationLabel.text = viewModel.durationString()
        }

        self.playButton.setImage(viewModel.imageForPlayButton(), for: .normal)
        self.bindSelectedState(viewModel: viewModel)
    }

    func bindSelectedState(viewModel: SelectAudioItemViewModel) {
        self.selectButton.setImage(viewModel.imageForSelectButton(), for: .normal)
    }

    func startScrolling() {
        self.scrollableLabel.startAnimation()
        self.titleStaticLabel.isHidden = true
        self.scrollableLabel.isHidden = !self.titleStaticLabel.isHidden
    }

    func stopScrolling() {
        self.scrollableLabel.stopAnimation()
        self.titleStaticLabel.isHidden = false
        self.scrollableLabel.isHidden = !self.titleStaticLabel.isHidden
    }
}

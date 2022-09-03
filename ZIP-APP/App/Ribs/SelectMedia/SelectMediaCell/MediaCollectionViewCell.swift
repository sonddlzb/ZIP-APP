//
//  MediaCollectionViewCell.swift
//  Zip
//
//  Created by đào sơn on 20/06/2022.
//

import UIKit
import Photos

protocol MediaCollectionViewCellDelegate: AnyObject {
    func mediaCollectionViewCell(didLongPressAt cell: MediaCollectionViewCell)
}

class MediaCollectionViewCell: UICollectionViewCell {

    // MARK: Outlets
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var mediaImageView: UIImageView!
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var checkedImageView: UIImageView!

    // MARK: Variables
    weak var delegate: MediaCollectionViewCellDelegate?
    private var viewModel: SelectMediaItemViewModel!
    private let bottomGradient = CAGradientLayer()

    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0x575FCC).withAlphaComponent(0.3)
        return view
    }()

    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cornerRadius = 4
        addBottomGradient()
        configViewForSelectedCell()
        addLongPressGestureRecognizer()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.bottomGradient.frame = gradientView.bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.mediaImageView.image = nil
    }

    // MARK: - Config cell
    func addLongPressGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(mediaCellLongPressed))
        self.addGestureRecognizer(longPressGesture)
    }

    func addBottomGradient() {
        bottomGradient.frame = gradientView.bounds
        bottomGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        bottomGradient.locations = [0, 1.0]
        gradientView.layer.insertSublayer(bottomGradient, at: 0)
        gradientView.isHidden = true
    }

    func configViewForSelectedCell() {
        self.mediaImageView.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: self.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        overlayView.isHidden = true
        checkedImageView.isHidden = true
    }

    // MARK: - Action
    @objc func mediaCellLongPressed(_ sender: UILongPressGestureRecognizer) {
        delegate?.mediaCollectionViewCell(didLongPressAt: self)
    }

    // MARK: - Helper
    func displayVideoMode() {
        durationLabel.isHidden = false
        durationLabel.text = viewModel.asset.formatVideoDuration()
        gradientView.isHidden = false
    }

    func displayImageMode() {
        durationLabel.isHidden = true
        gradientView.isHidden = true
    }

    // MARK: - Binding
    func bind(viewModel: SelectMediaItemViewModel) {
        self.viewModel = viewModel

        self.bindSelectedState(itemViewModel: viewModel)
        viewModel.asset.mediaType == .video ? displayVideoMode() : displayImageMode()

        let currentIdentifier = viewModel.asset.localIdentifier
        viewModel.fetchThumbnail(completion: { image in
            if currentIdentifier == self.viewModel.asset.localIdentifier {
                self.mediaImageView.image = image
            }
        })
    }

    func bindSelectedState(itemViewModel: SelectMediaItemViewModel) {
        checkedImageView.isHidden = !itemViewModel.isSelected
        overlayView.isHidden = !itemViewModel.isSelected
    }
}

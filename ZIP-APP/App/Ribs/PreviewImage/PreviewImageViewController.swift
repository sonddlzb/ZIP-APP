//
//  PreviewImageViewController.swift
//  Zip
//
//  Created by đào sơn on 03/09/2022.
//

import RIBs
import RxSwift
import UIKit
import Photos

protocol PreviewImagePresentableListener: AnyObject {
    func didTapCancelButton()
}

final class PreviewImageViewController: BaseViewControler, PreviewImageViewControllable {

    // MARK: Outlets
    @IBOutlet private weak var headerGradientView: UIView!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var previewImageView: UIImageView!

    // MARK: Variables
    weak var listener: PreviewImagePresentableListener?
    var previewImageViewModel: PreviewImageViewModel?
    private var previewImage: UIImage?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initBasicGUI()
    }

    override func viewWillDisappearByInteractive() {
        super.viewWillDisappearByInteractive()
        listener?.didTapCancelButton()
    }

    // MARK: - Config
    func initBasicGUI() {
        addTopGradient()
    }

    func addTopGradient() {
        let topGradient = CAGradientLayer()
        topGradient.frame = headerGradientView.bounds
        topGradient.colors = [UIColor(rgb: 0, alpha: 0.4).cgColor, UIColor(rgb: 0, alpha: 0).cgColor]
        topGradient.locations = [0, 1.0]
        headerGradientView.layer.insertSublayer(topGradient, at: 0)
    }

    // MARK: Actions
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        listener?.didTapCancelButton()
    }
}

// MARK: PreviewImagePresentable
extension PreviewImageViewController: PreviewImagePresentable {
    func bind(viewModel: PreviewImageViewModel) {
        self.previewImageViewModel = viewModel
        self.loadViewIfNeeded()
        self.previewImageViewModel?.fetchImage(completion: {[weak self] image in
            self?.previewImageView.image = image
        })
    }
}

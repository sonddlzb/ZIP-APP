//
//  ExtractLoadingViewController.swift
//  Zip
//
//

import RIBs
import RxSwift
import UIKit
import Lottie

protocol ExtractLoadingPresentableListener: AnyObject {
}

final class ExtractLoadingViewController: BaseViewControler, ExtractLoadingPresentable, ExtractLoadingViewControllable {
    @IBOutlet private weak var blurView: SolarBlurView!
    @IBOutlet private weak var gifView: LottieAnimationView!

    weak var listener: ExtractLoadingPresentableListener?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.blurView.setupBlurAnimator()
        }
    }

    // MARK: - Config
    private func config() {
        self.gifView.play(fromProgress: 0, toProgress: 0.75, loopMode: .playOnce) { [weak self] _ in
            self?.gifView.play(fromProgress: 0.2, toProgress: 0.75, loopMode: .loop, completion: nil)
        }
    }
}

//
//  CompressLoadingViewController.swift
//  Zip
//
//

import RIBs
import RxSwift
import UIKit
import Lottie

protocol CompressLoadingPresentableListener: AnyObject {
}

final class CompressLoadingViewController: BaseViewControler, CompressLoadingPresentable, CompressLoadingViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var blurView: SolarBlurView!
    @IBOutlet private weak var gifView: LottieAnimationView!

    weak var listener: CompressLoadingPresentableListener?

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
        self.gifView.play { [weak self] _ in
            self?.gifView.play(fromProgress: 0.5, toProgress: 1, loopMode: .loop, completion: nil)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForegroundNotification(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    // MARK: - Notification center
    @objc private func applicationWillEnterForegroundNotification(_ notification: Notification) {
        self.gifView.play(fromProgress: 0.5, toProgress: 1, loopMode: .loop, completion: nil)
    }
}

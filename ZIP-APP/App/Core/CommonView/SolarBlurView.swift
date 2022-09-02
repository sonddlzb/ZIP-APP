//
//  SolarBlurView.swift
//  Zip
//
//

import UIKit

class SolarBlurView: UIView {
    private var effectView: UIVisualEffectView!
    private var animator: UIViewPropertyAnimator?

    // MARK: - Init
    deinit {
        self.animator?.stopAnimation(true)
        self.animator = nil
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    // MARK: - Common init
    private func commonInit() {
        effectView = UIVisualEffectView(effect: nil)
        effectView.isUserInteractionEnabled = false
        self.addSubview(effectView)
        effectView.fitSuperviewConstraint()

        self.setupBlurAnimator()

        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForegroundNotification(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    // MARK: - Public method
    func setupBlurAnimator() {
        self.animator?.stopAnimation(true)
        self.effectView.effect = nil
        self.animator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
            self.effectView.effect = UIBlurEffect(style: .dark)
        })

        self.animator?.fractionComplete = 0.5
    }

    // MARK: - Notification Center
    @objc private func applicationWillEnterForegroundNotification(_ notification: Notification) {
        self.setupBlurAnimator()
    }
}

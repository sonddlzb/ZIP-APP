//
//  NotificationBannerView.swift
//  CommonUI
//
//

import UIKit

public enum NotificationBannerMode {
    case dark
    case lightBlur
}

public enum NotificationBannerIconType {
    case warning
    case success
}

public class NotificationBannerView: UIView {
    public static func show(_ message: String, mode: NotificationBannerMode = .dark, icon: NotificationBannerIconType, duration: Double = 3) {
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {
            return
        }

        if let oldBanner = window.subviews.first(where: {$0 is NotificationBannerView}) {
            oldBanner.removeFromSuperview()
        }

        let notificationBannerView = NotificationBannerView(message: message, mode: mode, icon: icon, duration: duration)
        notificationBannerView.config()

        window.addSubview(notificationBannerView)
        notificationBannerView.fitSuperviewConstraint()

        notificationBannerView.startShowingAnimation()
        notificationBannerView.startAutoDismiss()
    }

    // MARK: - Touches
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.dismiss()
    }

    // MARK: - Init
    public init(message: String, mode: NotificationBannerMode, icon: NotificationBannerIconType, duration: Double = 3) {
        self.message = message
        self.mode = mode
        self.icon = icon
        self.duration = duration
        super.init(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        animator?.stopAnimation(true)
    }

    // MARK: - Variable
    private let mode: NotificationBannerMode
    private let icon: NotificationBannerIconType
    private let duration: Double
    let message: String

    private var blurView: UIVisualEffectView?
    private var animator: UIViewPropertyAnimator?

    private lazy var bundle: Bundle = { .main }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.cornerRadius = 16
        return view
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.text = message
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: icon == .warning ? "ic_warning" : "ic_success", in: bundle)
        return imageView
    }()

    // MARK: - Config
    private func config() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(imageView)
        containerView.addSubview(messageLabel)
        self.addSubview(containerView)

        var activeConstraints: [NSLayoutConstraint] = [
            containerView.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 24),
            containerView.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -24),
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            imageView.widthAnchor.constraint(equalToConstant: 44),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            imageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20),
            imageView.rightAnchor.constraint(equalTo: messageLabel.leftAnchor, constant: -20),
            imageView.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 17),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -17),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            messageLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20),
            messageLabel.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 20),
            messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -20),
            messageLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ]

        if mode == .dark {
            activeConstraints.append(containerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -24))
        } else {
            activeConstraints.append(containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor))
        }

        NSLayoutConstraint.activate(activeConstraints)
        configBackground()
    }

    private func configBackground() {
        if mode == .dark {
            containerView.backgroundColor = UIColor(rgb: 0x18191F)
            return
        }

        containerView.borderColor = UIColor(rgb: 0x676767)
        containerView.borderWidth = 2
        containerView.backgroundColor = .clear

        blurView = UIVisualEffectView(effect: nil)
        blurView?.backgroundColor = .clear
        containerView.insertSubview(blurView!, at: 0)
        blurView?.fitSuperviewConstraint()
        configBlurAnimator()
        configNotificationCenter()
    }

    private func configBlurAnimator() {
        blurView?.effect = nil
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
            self.blurView?.effect = UIBlurEffect(style: .light)
        })

        animator?.fractionComplete = 0.5
    }

    private func configNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForegroundNotification(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    // MARK: - Notification
    @objc private func applicationWillEnterForegroundNotification(_ notification: Notification) {
        configBlurAnimator()
    }

    // MARK: - Animation
    private func startShowingAnimation() {
        self.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }

    @objc private func dismiss() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(dismiss), object: nil)

        self.alpha = 1
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }

    private func startAutoDismiss() {
        self.perform(#selector(dismiss), with: nil, afterDelay: duration)
    }
}

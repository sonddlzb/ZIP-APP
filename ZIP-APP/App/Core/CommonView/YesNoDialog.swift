//
//  YesNoDialog.swift
//  Zip
//
//

import UIKit

enum YesNoDialogActionType {
    case normal
    case delete

    func text() -> String {
        switch self {
        case .normal:
            return "OK"
        case .delete:
            return "Delete"
        }
    }

    func textColor() -> UIColor {
        switch self {
        case .normal:
            return UIColor(rgb: 0x575FCC)
        case .delete:
            return UIColor(rgb: 0xFF2C2C)
        }
    }
}

class YesNoDialog: UIView {
    static func loadView() -> YesNoDialog {
        return YesNoDialog.loadView(fromNib: "YesNoDialog")!
    }

    static func show(title: String, message: String, actionType: YesNoDialogActionType = .normal, action: (() -> Void)? = nil, cancelAction: (() -> Void)? = nil) {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            return
        }

        let dialog = Self.loadView()
        dialog.bind(title: title, message: message, actionType: actionType, action: action, cancelAction: cancelAction)
        dialog.alpha = 0
        window.addSubview(dialog)
        dialog.setupBlurAnimator()
        dialog.fitSuperviewConstraint()
        dialog.superview?.layoutIfNeeded()

        UIView.animate(withDuration: 0.25) {
            dialog.alpha = 1
        }
    }

    // MARK: - Outlets
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var okLabel: UILabel!

    private var action: (() -> Void)?
    private var cancelAction: (() -> Void)?
    private var blurView: SolarBlurView!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.config()
    }

    private func config() {
        self.configBlurView()
    }

    private func configBlurView() {
        self.blurView = SolarBlurView()
        self.insertSubview(blurView, at: 0)
        self.blurView.fitSuperviewConstraint()
    }

    private func setupBlurAnimator() {
        self.blurView.setupBlurAnimator()
    }

    // MARK: - Action
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        self.cancelAction?()
        self.dismiss()
    }

    @IBAction func okButtonDidTap(_ sender: Any) {
        self.action?()
        self.dismiss()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let point = touches.first?.location(in: self),
           !self.contentView.frame.contains(point) {
            self.cancelAction?()
            self.dismiss()
        }
    }

    // MARK: - Helper
    private func bind(title: String, message: String, actionType: YesNoDialogActionType, action: (() -> Void)?, cancelAction: (() -> Void)?) {
        self.titleLabel.text = title
        self.messageLabel.text = message
        self.okLabel.text = actionType.text()
        self.okLabel.textColor = actionType.textColor()
        self.action = action
        self.cancelAction = cancelAction
    }

    private func dismiss() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}

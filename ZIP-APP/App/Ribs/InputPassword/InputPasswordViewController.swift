//
//  InputPasswordViewController.swift
//  Zip
//
//

import RIBs
import RxSwift
import UIKit

protocol InputPasswordPresentableListener: AnyObject {
    func didSelectCancel()
    func didSelectOK()
    func didEditPassword(password: String)
}

final class InputPasswordViewController: BaseViewControler, InputPasswordViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var passwordTextField: PasswordTextField!
    @IBOutlet private weak var okLabel: UILabel!
    @IBOutlet private weak var okButton: TapableView!
    @IBOutlet private weak var blurView: SolarBlurView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var bottomContentAreaConstraint: NSLayoutConstraint!

    weak var listener: InputPasswordPresentableListener?
    var viewModel: InputPasswordViewModel!

    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.first?.view == self.blurView {
            self.passwordTextField.endEditing(true)
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.blurView.setupBlurAnimator()
            self.passwordTextField.becomeFirstResponder()
        }
    }

    // MARK: - Config
    private func config() {
        self.passwordTextField.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: UITextField.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: UIApplication.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Notification center
    @objc private func keyboardWillShowNotification(_ notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        UIView.animate(withDuration: 0.25) {
            self.bottomContentAreaConstraint.constant = keyboardFrame.cgRectValue.height
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHideNotification(_ notification: Notification) {
        UIView.animate(withDuration: 0.25) {
            self.bottomContentAreaConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - Action
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        listener?.didSelectCancel()
    }

    @IBAction func okButtonDidTap(_ sender: Any) {
        listener?.didSelectOK()
    }
}

// MARK: - InputPasswordPresentable
extension InputPasswordViewController: InputPasswordPresentable {
    func bind(viewModel: InputPasswordViewModel) {
        self.loadViewIfNeeded()
        self.viewModel = viewModel
        if self.viewModel.isIncorrectPassword {
            self.passwordTextField.displayIncorrectPassword()
        } else {
            self.passwordTextField.placeholder = viewModel.placeholder()
        }

        self.okLabel.textColor = viewModel.okButtonTextColor()
        self.okButton.isUserInteractionEnabled = viewModel.canOKButtonInteract()
    }

    func clearPassword() {
        self.loadViewIfNeeded()
        self.passwordTextField.text = ""
    }
}

// MARK: - SolarTextFieldDelegate
extension InputPasswordViewController: SolarTextFieldDelegate {
    func solarTextField(_ textField: SolarTextField, willChangeToText text: String) -> Bool {
        listener?.didEditPassword(password: text)
        return true
    }
}

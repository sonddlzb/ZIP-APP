//
//  InputToCompressViewController.swift
//  Zip
//
//

import RIBs
import RxSwift
import UIKit

protocol InputToCompressPresentableListener: AnyObject {
    func didSelectCancel()
    func didSelectOK(name: String)
    func didSetUsePassword(isOn: Bool)
    func didSetReduceFileSize(isOn: Bool)
}

final class InputToCompressViewController: BaseViewControler, InputToCompressViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var reduceSizeSwitch: UISwitch!
    @IBOutlet private weak var usePasswordSwitch: UISwitch!
    @IBOutlet private weak var nameTextField: SolarTextField!
    @IBOutlet private weak var okButton: TapableView!
    @IBOutlet private weak var blurView: SolarBlurView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var okLabel: UILabel!
    @IBOutlet private weak var bottomBackgroundViewConstraint: NSLayoutConstraint!

    weak var listener: InputToCompressPresentableListener?
    private var viewModel: InputToCompressViewModel!

    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.first?.view == self.containerView {
            self.nameTextField.endEditing(true)
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
            self.nameTextField.becomeFirstResponder()
        }
    }

    // MARK: - Config
    private func config() {
        self.nameTextField.delegate = self
        self.nameTextField.textAlignment = .center
        self.nameTextField.placeholder = "File name cannot be empty"
        self.nameTextField.attributedPlaceholder = NSAttributedString(string: self.nameTextField.placeholder!, attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .regular),
            .foregroundColor: UIColor(rgb: 0xCACACA)
        ])

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: UITextField.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: UITextField.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Notification center
    @objc private func keyboardWillShowNotification(_ notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        UIView.animate(withDuration: 0.25) {
            self.bottomBackgroundViewConstraint.constant = keyboardFrame.cgRectValue.height
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHideNotification(_ notification: Notification) {
        UIView.animate(withDuration: 0.25) {
            self.bottomBackgroundViewConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - Action
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        listener?.didSelectCancel()
    }

    @IBAction func okButtonDidTap(_ sender: Any) {
        listener?.didSelectOK(name: self.viewModel.name)
    }

    @IBAction func usePasswordSwitchDidChangeValue(_ sender: Any) {
        listener?.didSetUsePassword(isOn: self.usePasswordSwitch.isOn)
    }

    @IBAction func reduceSizeSwitchDidChangeValue(_ sender: Any) {
        listener?.didSetReduceFileSize(isOn: self.reduceSizeSwitch.isOn)
    }
}

// MARK: - InputToCompressPresentable
extension InputToCompressViewController: InputToCompressPresentable {
    func bind(viewModel: InputToCompressViewModel) {
        self.loadViewIfNeeded()
        self.viewModel = viewModel
        self.nameTextField.text = viewModel.name
        self.usePasswordSwitch.isOn = viewModel.isUsePassword
        self.reduceSizeSwitch.isOn = viewModel.isReduceFile
        self.okButton.isUserInteractionEnabled = self.viewModel.isOkActionEnabled()
        self.okLabel.textColor = self.viewModel.actionTextColor()
    }
}

// MARK: - SolarTextFieldDelegate
extension InputToCompressViewController: SolarTextFieldDelegate {
    func solarTextField(_ textField: SolarTextField, willChangeToText text: String) -> Bool {
        self.viewModel.name = text.trim()
        okButton.isUserInteractionEnabled = self.viewModel.isOkActionEnabled()
        okLabel.textColor = self.viewModel.actionTextColor()
        return text.first != " "
    }

    func solarTextFieldShouldReturn(_ textField: SolarTextField) -> Bool {
        if okButton.isUserInteractionEnabled {
            listener?.didSelectOK(name: self.viewModel.name)
        }

        return true
    }
}

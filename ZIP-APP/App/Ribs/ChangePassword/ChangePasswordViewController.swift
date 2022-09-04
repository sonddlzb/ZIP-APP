//
//  ChangePasswordViewController.swift
//  Zip
//
//  Created by đào sơn on 01/09/2022.
//

import RIBs
import RxSwift
import UIKit

protocol ChangePasswordPresentableListener: AnyObject {
    func didTapExitButton()
    func didEndEditPassword(yourPassword: String, newPassword: String, confirmPassword: String)
    func didTapUpdateButton()
}

final class ChangePasswordViewController: BaseViewControler, ChangePasswordViewControllable {
    // MARK: Outlets
    @IBOutlet private weak var blurView: SolarBlurView!
    @IBOutlet private weak var exitButton: UIButton!
    @IBOutlet private weak var yourPasswordTextField: PasswordTextField!
    @IBOutlet private weak var newPasswordTextField: PasswordTextField!
    @IBOutlet private weak var confirmPasswordTextField: PasswordTextField!
    @IBOutlet private weak var changePasswordLabel: UILabel!
    @IBOutlet private weak var updateButton: UIButton!
    @IBOutlet private weak var invalidLabel: UILabel!

    // MARK: Variables
    weak var listener: ChangePasswordPresentableListener?
    var viewModel = ChangePasswordViewModel()

    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.blurView.setupBlurAnimator()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initBasicGUI()
        yourPasswordTextField.becomeFirstResponder()
    }

    override func viewWillDisappearByInteractive() {
        super.viewWillDisappearByInteractive()
        listener?.didTapExitButton()
    }

    // MARK: - Config
    func initBasicGUI() {
        exitButton.setTitle("", for: .normal)
        configYourPasswordTextField()
        configNewPasswordTextField()
        configConfirmPasswordTextField()
        configUpdateButton()
        configInvalidLabel()
    }

    @objc func textFieldDidChange() {
        listener?.didEndEditPassword(yourPassword: yourPasswordTextField.text, newPassword: newPasswordTextField.text, confirmPassword: confirmPasswordTextField.text)
    }

    func addShadowEffectToUpdateButton() {
        let shadowSize: CGFloat = 10
        let shadowRect: CGRect = CGRect(x: -shadowSize / 2,
                                        y: -shadowSize / 2,
                                        width: updateButton.frame.size.width + shadowSize,
                                        height: updateButton.frame.size.height + shadowSize)
        let shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: 100.0)
        updateButton.layer.shadowColor = UIColor(rgb: 0xFF6C39).withAlphaComponent(0.7).cgColor
        updateButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        updateButton.layer.shadowOpacity = 0.5
        updateButton.layer.shadowPath = shadowPath.cgPath
        updateButton.layer.masksToBounds = true
    }

    // MARK: Config
    func configYourPasswordTextField() {
        yourPasswordTextField.isHighlightedWhenEditting = true
        yourPasswordTextField.layer.cornerRadius = 10
        yourPasswordTextField.backgroundColor = UIColor(rgb: 0xF7F7F7)
        yourPasswordTextField.borderColor = UIColor(rgb: 0x575FCC)
        yourPasswordTextField.placeholder = "Your password"
        yourPasswordTextField.paddingLeft = 10
        yourPasswordTextField.delegate = self
    }

    func configNewPasswordTextField() {
        newPasswordTextField.isHighlightedWhenEditting = true
        newPasswordTextField.layer.cornerRadius = 10
        newPasswordTextField.backgroundColor = UIColor(rgb: 0xF7F7F7)
        newPasswordTextField.borderColor = UIColor(rgb: 0x575FCC)
        newPasswordTextField.placeholder = "New password"
        newPasswordTextField.paddingLeft = 10
        newPasswordTextField.delegate = self
    }

    func configConfirmPasswordTextField() {
        confirmPasswordTextField.isHighlightedWhenEditting = true
        confirmPasswordTextField.layer.cornerRadius = 10
        confirmPasswordTextField.backgroundColor = UIColor(rgb: 0xF7F7F7)
        confirmPasswordTextField.borderColor = UIColor(rgb: 0x575FCC)
        confirmPasswordTextField.placeholder = "Confirm password"
        confirmPasswordTextField.paddingLeft = 10
        confirmPasswordTextField.delegate = self
    }

    func configUpdateButton() {
        updateButton.layer.cornerRadius = 20
        updateButton.isEnabled = false
        addShadowEffectToUpdateButton()
    }

    func configInvalidLabel() {
        invalidLabel.text = "Invalid password"
        invalidLabel.textColor = UIColor(rgb: 0xFF6C39)
        invalidLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        invalidLabel.isHidden = true
    }

    // MARK: Actions
    @IBAction func exitButtonDidTap(_ sender: UIButton) {
        listener?.didTapExitButton()
    }
    @IBAction func updateButtonDidTap(_ sender: UIButton) {
        listener?.didTapUpdateButton()
    }
}

// MARK: ChangePasswordPresentable
extension ChangePasswordViewController: ChangePasswordPresentable {
    func bind(viewModel: ChangePasswordViewModel) {
        self.loadViewIfNeeded()
        self.viewModel = viewModel
        let isUpdateButtonEnable = self.viewModel.isUpdateButtonEnable()
        updateButton.isEnabled = isUpdateButtonEnable
        updateButton.layer.masksToBounds = !isUpdateButtonEnable
        updateButton.backgroundColor = self.viewModel.getUpdateButtonColor()
        invalidLabel.isHidden = self.viewModel.isInvalidLabelHidden()
        invalidLabel.text = self.viewModel.invalidLabelContent()
    }
}

// MARK: SolarTextFieldDelegate
extension ChangePasswordViewController: SolarTextFieldDelegate {
    func solarTextField(_ textField: SolarTextField, willChangeToText text: String) -> Bool {
        return true
    }

    func solarTextField(addTextFieldChangedValueObserverTo textField: PaddingTextField) {
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
}

// MARK: ChangePasswordViewControllerExtension
extension ChangePasswordViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

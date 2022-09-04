//
//  CreatePasswordViewController.swift
//  Zip
//
//  Created by đào sơn on 31/08/2022.
//

import RIBs
import RxSwift
import UIKit

protocol CreatePasswordPresentableListener: AnyObject {
    func didTapExitButton()
    func didEndEditPassword(enterPassword: String, confirmPassword: String)
    func didTapCreateButton()
}

final class CreatePasswordViewController: BaseViewControler, CreatePasswordViewControllable {
    // MARK: Outlets
    @IBOutlet private weak var exitButton: UIButton!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var createButton: UIButton!
    @IBOutlet private weak var enterPasswordTextField: PasswordTextField!
    @IBOutlet private weak var confirmPasswordTextField: PasswordTextField!
    @IBOutlet private weak var invalidLabel: UILabel!
    @IBOutlet private weak var blurView: SolarBlurView!

    // MARK: Variables
    weak var listener: CreatePasswordPresentableListener?
    var viewModel = CreatePasswordViewModel()

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
        enterPasswordTextField.becomeFirstResponder()
    }

    override func viewWillDisappearByInteractive() {
        super.viewWillDisappearByInteractive()
        listener?.didTapExitButton()
    }

    // MARK: - Config
    func initBasicGUI() {
        exitButton.setTitle("", for: .normal)
        configEnterPasswordTextField()
        configConfirmPasswordTextField()
        configInvalidLabel()
        configCreateButton()
    }

    @objc func textFieldDidChange() {
        listener?.didEndEditPassword(enterPassword: self.enterPasswordTextField.text,
                                     confirmPassword: self.confirmPasswordTextField.text)
    }

    func addShadowEffectToCreateButton() {
        let shadowSize: CGFloat = 10
        let shadowRect: CGRect = CGRect(x: -shadowSize / 2,
                                        y: -shadowSize / 2,
                                        width: createButton.frame.size.width + shadowSize,
                                        height: createButton.frame.size.height + shadowSize)
        let shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: 100.0)
        createButton.layer.shadowColor = UIColor(rgb: 0xFF6C39).withAlphaComponent(0.7).cgColor
        createButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        createButton.layer.shadowOpacity = 0.5
        createButton.layer.shadowPath = shadowPath.cgPath
        createButton.layer.masksToBounds = true
    }

    // MARK: Config
    func configEnterPasswordTextField() {
        enterPasswordTextField.isHighlightedWhenEditting = true
        enterPasswordTextField.layer.cornerRadius = 10
        enterPasswordTextField.backgroundColor = UIColor(rgb: 0xF7F7F7)
        enterPasswordTextField.borderColor = UIColor(rgb: 0x575FCC)
        enterPasswordTextField.placeholder = "Enter password"
        enterPasswordTextField.paddingLeft = 10
        enterPasswordTextField.delegate = self
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

    func configCreateButton() {
        createButton.layer.cornerRadius = 20
        createButton.isEnabled = false
        addShadowEffectToCreateButton()
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

    @IBAction func createButtonDidTap(_ sender: UIButton) {
        listener?.didTapCreateButton()
    }
}

// MARK: CreatePasswordPresentable
extension CreatePasswordViewController: CreatePasswordPresentable {
    func bind(viewModel: CreatePasswordViewModel) {
        self.loadViewIfNeeded()
        self.viewModel = viewModel
        let isCreateButtonEnable = self.viewModel.isCreateButtonEnable()
        createButton.isEnabled = isCreateButtonEnable
        createButton.layer.masksToBounds = !isCreateButtonEnable
        createButton.backgroundColor = self.viewModel.createButtonColor()
        invalidLabel.isHidden = self.viewModel.isInvalidLabelHidden()
        invalidLabel.text = self.viewModel.invalidLabelContent()
    }
}

// MARK: SolarTextFieldDelegate
extension CreatePasswordViewController: SolarTextFieldDelegate {
    func solarTextField(_ textField: SolarTextField, willChangeToText text: String) -> Bool {
        return true
    }

    func solarTextField(addTextFieldChangedValueObserverTo textField: PaddingTextField) {
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
}

// MARK: CreatePasswordViewControllerExtension
extension CreatePasswordViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

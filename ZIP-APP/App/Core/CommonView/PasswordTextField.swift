//
//  PasswordTextField.swift
//  Zip
//
//

import UIKit

class PasswordTextField: SolarTextField {
    var paddingLeft: CGFloat = 0 {
        didSet {
            self.textField.paddingLeft = paddingLeft
        }
    }

    var paddingRight: CGFloat = 0 {
        didSet {
            self.rightButtonConstraint.constant = -paddingRight
        }
    }

    // MARK: - UI
    private var rightButton: UIButton!
    private var rightButtonConstraint: NSLayoutConstraint!

    // MARK: - Config
    override func commonInit() {
        super.commonInit()
        self.isSecureText = true
    }

    override func configTextField() {
        super.configTextField()
        self.textField.keyboardType = .numberPad
        self.configRightButton()
    }

    private func configRightButton() {
        self.rightButton = UIButton()
        self.rightButton.addTarget(self, action: #selector(rightViewDidTap), for: .touchUpInside)
        self.rightButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.rightButton)

        self.rightTextFieldConstrant.isActive = false
        self.rightButtonConstraint = self.rightButton.rightAnchor.constraint(equalTo: self.rightAnchor)
        NSLayoutConstraint.activate([
            self.rightButton.widthAnchor.constraint(equalToConstant: 30),
            self.rightButton.heightAnchor.constraint(equalToConstant: 30),
            self.rightButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.rightButton.leftAnchor.constraint(equalTo: self.textField.rightAnchor, constant: 5),
            self.rightButtonConstraint
        ])
    }

    // MARK: - Override
    override func didSetSecureText() {
        super.didSetSecureText()
        let image = UIImage(named: self.isSecureText ? "ic_password_hide" : "ic_password_show")
        self.rightButton.setImage(image, for: .normal)
    }

    override func didChangePlaceHolder() {
        self.textField.attributedPlaceholder = self.attributedPlaceholder(for: self.textField.placeholder ?? "")
    }

    @objc private func rightViewDidTap() {
        self.isSecureText = !self.isSecureText
    }

    // MARK: - Public method
    func displayIncorrectPassword() {
        self.textField.text = ""
        self.textField.placeholder = "Incorrect password"
        self.textField.attributedPlaceholder = NSAttributedString(string: self.textField.placeholder!, attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .medium),
            .foregroundColor: UIColor(rgb: 0xFF6C39)
        ])
    }

    // MARK: - Helper
    private func attributedPlaceholder(for text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .regular),
            .foregroundColor: UIColor(rgb: 0xCACACA)
        ])
    }
}

extension PasswordTextField {
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        self.textField.placeholder = self.placeholder
        self.textField.attributedPlaceholder = self.attributedPlaceholder(for: self.placeholder ?? "")
    }
}

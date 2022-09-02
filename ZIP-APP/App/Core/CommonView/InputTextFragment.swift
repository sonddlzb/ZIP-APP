//
//  InputTextFragment.swift
//  Zip
//
//

import UIKit

@objc protocol InputTextFragmentDelegate: AnyObject {
    func inputTextFragmentDidSelectCancel(_ fragment: InputTextFragment)
    func inputTextFragment(_ fragment: InputTextFragment, didSelectOK text: String)
    @objc optional func inputTextFragment(_ fragment: InputTextFragment, shouldChangeTextTo text: String) -> Bool
    @objc optional func inputTextFragment(_ fragment: InputTextFragment, willShowKeyboard keyboardHeight: CGFloat)
    @objc optional func inputTextFragment(_ fragment: InputTextFragment, willHideKeyboard keyboardHeight: CGFloat)
}

class InputTextFragment: UIView {
    static func loadView() -> InputTextFragment {
        return InputTextFragment.loadView(fromNib: "InputTextFragment")!
    }

    // MARK: - Public property
    weak var delegate: InputTextFragmentDelegate?
    var isPreventingEmptyEnable: Bool = true {
        didSet {
            self.okButton.isUserInteractionEnabled = !text.isEmpty && isPreventingEmptyEnable
            self.okLabel.textColor = UIColor(rgb: self.okButton.isUserInteractionEnabled ? 0x575FCC : 0xAAAAAA)
        }
    }

    var placeholder: String? {
        get {
            self.textField.placeholder
        }

        set {
            self.textField.placeholder = newValue
            self.applyAttributedStringForPlaceholder()
        }
    }

    var text: String {
        get {
            self.textField.text.trim()
        }

        set {
            self.textField.text = newValue
            self.refreshOKButton(text: newValue)
        }
    }

    var title: String {
        get {
            self.titleLabel.text ?? ""
        }

        set {
            self.titleLabel.text = newValue
        }
    }

    // MARK: - Outlets
    @IBOutlet private weak var textField: SolarTextField!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var okLabel: UILabel!
    @IBOutlet private weak var okButton: TapableView!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.textField.delegate = self
        self.textField.textAlignment = .center
        self.applyAttributedStringForPlaceholder()
        self.refreshOKButton(text: "")

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: UITextField.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: UITextField.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Action
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        delegate?.inputTextFragmentDidSelectCancel(self)
    }

    @IBAction func okButtonDidTap(_ sender: Any) {
        delegate?.inputTextFragment(self, didSelectOK: self.text)
    }

    // MARK: - Notification center
    @objc private func keyboardWillShowNotification(_ notification: Notification) {
        if let keyboardHeight = self.keyboardHeight(in: notification) {
            delegate?.inputTextFragment?(self, willShowKeyboard: keyboardHeight)
        }
    }

    @objc private func keyboardWillHideNotification(_ notification: Notification) {
        if let keyboardHeight = self.keyboardHeight(in: notification) {
            delegate?.inputTextFragment?(self, willHideKeyboard: keyboardHeight)
        }
    }

    // MARK: - Override
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        let becomeFirstResponder = super.becomeFirstResponder()
        return textField.becomeFirstResponder() || becomeFirstResponder
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        let resignFirstResponder = super.resignFirstResponder()
        return textField.resignFirstResponder() || resignFirstResponder
    }

    // MARK: - Helper
    private func keyboardHeight(in notification: Notification) -> CGFloat? {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            return keyboardHeight
        }

        return nil
    }

    private func applyAttributedStringForPlaceholder() {
        if let placeholder = self.textField.placeholder {
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
                .font: UIFont.systemFont(ofSize: 17, weight: .regular)
            ])
        }
    }
}

// MARK: - SolarTextFieldDelegate
extension InputTextFragment: SolarTextFieldDelegate {
    func solarTextField(_ textField: SolarTextField, willChangeToText text: String) -> Bool {
        self.refreshOKButton(text: text)
        return text.first != " "
    }

    private func refreshOKButton(text: String) {
        let isTextEmpty = isPreventingEmptyEnable && !text.isEmpty
        let isUserInteractionActive = self.delegate?.inputTextFragment?(self, shouldChangeTextTo: text) ?? true
        self.okButton.isUserInteractionEnabled = isTextEmpty && isUserInteractionActive
        self.okLabel.textColor = UIColor(rgb: self.okButton.isUserInteractionEnabled ? 0x575FCC : 0xAAAAAA)
    }
}

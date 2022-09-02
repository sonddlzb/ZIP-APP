//
//  PaddingTextField.swift
//  Zip
//
//

import UIKit

public class PaddingTextField: UITextField {
    @IBInspectable public var paddingLeft: CGFloat = 0
    @IBInspectable public var paddingRight: CGFloat = 0
    @IBInspectable public var paddingTop: CGFloat = 0
    @IBInspectable public var paddingBottom: CGFloat = 0

    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingLeft,
                      y: bounds.origin.y + paddingTop,
                      width: bounds.size.width - paddingLeft - paddingRight,
                      height: bounds.size.height - paddingTop - paddingBottom)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}

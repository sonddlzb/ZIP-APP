//
//  HighlightableButton.swift
//  Core
//
//

import UIKit

open class HighlightableButton: UIControl {
    @IBInspectable var scaleOnHighlight: CGFloat = 0.8
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.animate(alpha: 0.6, scale: self.scaleOnHighlight)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.animate(alpha: 1, scale: 1)
        super.touchesEnded(touches, with: event)
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.animate(alpha: 1, scale: 1)
    }

    private func animate(alpha: CGFloat, scale: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.alpha = alpha
            if scale == 1 {
                self.transform = .identity
            } else {
                self.transform = CGAffineTransform.init(scaleX: scale, y: scale)
            }
        }
    }
}

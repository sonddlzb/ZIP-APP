import UIKit

open class ExtensibleTouchView: UIView {
    open var areaInteractiveInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return self.bounds.inset(by: areaInteractiveInsets).contains(point)
    }
}

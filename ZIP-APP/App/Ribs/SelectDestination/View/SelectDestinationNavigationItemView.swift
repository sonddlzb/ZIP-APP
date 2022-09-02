//
//  SelectDestinationNavigationItemView.swift
//  Zip
//
//

import UIKit

class SelectDestinationNavigationItemView: TapableView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = UIColor(rgb: 0x6F7481)
        return label
    }()

    // MARK: - Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    // MARK: - Common init
    private func commonInit() {
        self.scaleOnHighlight = 1
        self.addSubview(self.titleLabel)
        self.titleLabel.fitSuperviewConstraint()
    }

    // MARK: - Method
    func select() {
        titleLabel.textColor = UIColor(rgb: 0x283244)
    }

    func unselect() {
        titleLabel.textColor = UIColor(rgb: 0x6F7481)
    }

    func setText(_ text: String) {
        self.titleLabel.text = text
        self.titleLabel.sizeToFit()
    }
}

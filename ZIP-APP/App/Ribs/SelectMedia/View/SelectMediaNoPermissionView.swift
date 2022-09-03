//
//  SelectMediaNoPermissionView.swift
//  Zip
//
//  Created by đào sơn on 06/07/2022.
//

import UIKit

protocol SelectMediaNoPermissionViewDelegate: AnyObject {
    func selectMediaNoPermissionViewDidGrantAccess(_ view: SelectMediaNoPermissionView)
}

class SelectMediaNoPermissionView: UIView {
    weak var delegate: SelectMediaNoPermissionViewDelegate?

    @IBOutlet weak var grantAccessButton: TapableView!

    static func loadView() -> SelectMediaNoPermissionView {
        let view = SelectMediaNoPermissionView.loadView(fromNib: "SelectMediaNoPermissionView")!
        return view
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.grantAccessButton.layoutIfNeeded()
        self.grantAccessButton.cornerRadius = self.grantAccessButton.frame.height/2
    }

    @IBAction func grantAccessButtonDidTap(_ sender: Any) {
        self.delegate?.selectMediaNoPermissionViewDidGrantAccess(self)
    }
}

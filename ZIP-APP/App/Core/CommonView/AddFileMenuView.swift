//
//  AddFileMenuView.swift
//  Zip
//
//

import UIKit

protocol AddFileMenuViewDelegate: AnyObject {
    func addFileMenuViewDidSelectPhoto(_ view: AddFileMenuView)
    func addFileMenuViewDidSelectAudio(_ view: AddFileMenuView)
}

class AddFileMenuView: UIView {

    static func loadView() -> AddFileMenuView {
        let view = AddFileMenuView.loadView(fromNib: "AddFileMenuView")!
        return view
    }

    weak var delegate: AddFileMenuViewDelegate?

    // MARK: - Action
    @IBAction func photoButtonDidTap(_ sender: Any) {
        delegate?.addFileMenuViewDidSelectPhoto(self)
    }

    @IBAction func audioButtonDidTap(_ sender: Any) {
        delegate?.addFileMenuViewDidSelectAudio(self)
    }
}

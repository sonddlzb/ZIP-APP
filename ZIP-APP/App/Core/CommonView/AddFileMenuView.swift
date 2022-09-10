//
//  AddFileMenuView.swift
//  Zip
//
//

import UIKit

protocol AddFileMenuViewDelegate: AnyObject {
    func addFileMenuViewDidSelectPhoto(_ view: AddFileMenuView)
    func addFileMenuViewDidSelectAudio(_ view: AddFileMenuView)
    func addFileMenuViewDidSelectDocumentBrowser(_ view: AddFileMenuView)
    func addFileMenuViewDidSelectGoogleDrive(_ view: AddFileMenuView)
    func addFileMenuViewDidSelectOnedrive(_ view: AddFileMenuView)
    func addFileMenuViewDidSelectDropbox(_ view: AddFileMenuView)
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

    @IBAction func documentBrowserButtonDidTap(_ sender: Any) {
        delegate?.addFileMenuViewDidSelectDocumentBrowser(self)
    }

    @IBAction func googleDriveButtonDidTap(_ sender: Any) {
        delegate?.addFileMenuViewDidSelectGoogleDrive(self)
    }

    @IBAction func onedriveButtonDidTap(_ sender: Any) {
        delegate?.addFileMenuViewDidSelectOnedrive(self)
    }

    @IBAction func dropboxButtonDidTap(_ sender: Any) {
        delegate?.addFileMenuViewDidSelectDropbox(self)
    }
}

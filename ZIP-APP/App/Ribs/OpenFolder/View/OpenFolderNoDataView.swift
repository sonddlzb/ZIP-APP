//
//  OpenFolderNoDataView.swift
//  Zip
//
//

import UIKit

protocol OpenFolderNoDataViewDelegate: AddFileMenuViewDelegate {

}

class OpenFolderNoDataView: UIView {
    static func loadView() -> OpenFolderNoDataView {
        let view = OpenFolderNoDataView.loadView(fromNib: "OpenFolderNoDataView")!
        return view
    }

    // MARK: - Outlets
    @IBOutlet weak var containerAddFileMenuView: UIView!

    // MARK: - Variables
    weak var delegate: OpenFolderNoDataViewDelegate? {
        didSet {
            self.addFileMenuView.delegate = self.delegate
        }
    }

    private lazy var addFileMenuView: AddFileMenuView = {
        let view = AddFileMenuView.loadView()
        view.delegate = self.delegate
        return view
    }()

    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        self.config()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerAddFileMenuView.setupCornerRadius(topLeftRadius: 40, topRightRadius: 40, bottomLeftRadius: 0, bottomRightRadius: 0)
    }

    // MARK: - Config
    private func config() {
        self.containerAddFileMenuView.addSubview(self.addFileMenuView)
        self.addFileMenuView.fitSuperviewConstraint()

        self.containerAddFileMenuView.setupCornerRadius(topLeftRadius: 40, topRightRadius: 40, bottomLeftRadius: 0, bottomRightRadius: 0)
    }
}

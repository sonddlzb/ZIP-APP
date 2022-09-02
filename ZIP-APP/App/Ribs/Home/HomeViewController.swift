//
//  HomeViewController.swift
//  Zip
//
//  Created by Linh Nguyen Duc on 20/06/2022.
//

import UIKit

import RIBs
import RxSwift
import UniformTypeIdentifiers

protocol HomePresentableListener: AnyObject {
    func didSelectPhoto()
    func didSelectAudio()
    func didSelectSetting()
    func didSelectMyFile()
    func didSelectGoogleDrive()
    func didSelectDropbox()
    func didSelectOnedrive()
    func didSelectDocumentBrowser(urls: [URL])
    func willShowDocumentPickerToAddToMyFile()
}

final class HomeViewController: BaseViewControler, HomePresentable {
    // MARK: - Outlets
    @IBOutlet private weak var containerAddFileMenuView: UIView!

    weak var listener: HomePresentableListener?
    private lazy var addFileMenuView: AddFileMenuView = {
        let view = AddFileMenuView.loadView()
        view.delegate = self
        return view
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.containerAddFileMenuView.setupCornerRadius(topLeftRadius: 40, topRightRadius: 40, bottomLeftRadius: 0, bottomRightRadius: 0)
    }

    // MARK: - Config
    private func config() {
        self.configAddFileMenuView()
    }

    private func configAddFileMenuView() {
        self.containerAddFileMenuView.addSubview(self.addFileMenuView)
        self.addFileMenuView.fitSuperviewConstraint()
    }

    // MARK: - Action
    @IBAction func settingButtonDidTap(_ sender: Any) {
        listener?.didSelectSetting()
    }

    @IBAction func myFileButtonDidTap(_ sender: Any) {
        listener?.didSelectMyFile()
    }
}

// MARK: - HomeViewControllable
extension HomeViewController: HomeViewControllable {
    func showDocumentPicker() {
        let picker: UIDocumentPickerViewController
        if #available(iOS 14.0, *) {
            picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
        } else {
            picker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        }

        picker.delegate = self
        self.present(picker, animated: true) {
            picker.allowsMultipleSelection = true
        }
    }
}

// MARK: - AddFileMenuViewDelegate
extension HomeViewController: AddFileMenuViewDelegate {
    func addFileMenuViewDidSelectPhoto(_ view: AddFileMenuView) {
        listener?.didSelectPhoto()
    }

    func addFileMenuViewDidSelectAudio(_ view: AddFileMenuView) {
        listener?.didSelectAudio()
    }

    func addFileMenuViewDidSelectDocumentBrowser(_ view: AddFileMenuView) {
        listener?.willShowDocumentPickerToAddToMyFile()
        self.showDocumentPicker()
    }

    func addFileMenuViewDidSelectGoogleDrive(_ view: AddFileMenuView) {
        listener?.didSelectGoogleDrive()
    }

    func addFileMenuViewDidSelectOnedrive(_ view: AddFileMenuView) {
        listener?.didSelectOnedrive()
    }

    func addFileMenuViewDidSelectDropbox(_ view: AddFileMenuView) {
        listener?.didSelectDropbox()
    }
}

// MARK: - UIDocumentPickerDelegate
extension HomeViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        listener?.didSelectDocumentBrowser(urls: urls)
    }
}

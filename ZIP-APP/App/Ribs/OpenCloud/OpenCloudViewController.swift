//
//  OpenCloudViewController.swift
//  Zip
//
//

import RIBs
import RxSwift
import UIKit

private struct Const {
    static let collectionViewContentInset = UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 12)
    static let itemSpacing: CGFloat = 25
    static let lineSpacing: CGFloat = 15
    static let cellHeight: CGFloat = 68
}

protocol OpenCloudPresentableListener: AnyObject {
    func didSelectBack()
    func didSelectLogout()
    func didSelectFolder(viewModel: OpenCloudItemViewModel)
    func didSelectFile(itemViewModel: OpenCloudItemViewModel)
}

final class OpenCloudViewController: BaseViewControler, OpenCloudViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var backLabel: UILabel!

    private var viewModel: OpenCloudViewModel?
    weak var listener: OpenCloudPresentableListener?

    // MARK: - Override setting
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    override func viewWillDisappearByInteractive() {
        super.viewWillDisappearByInteractive()
        listener?.didSelectBack()
    }

    // MARK: - Config
    private func config() {
        self.collectionView.registerCell(type: CloudFileCell.self)
        self.collectionView.registerCell(type: CloudFolderCell.self)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.contentInset = Const.collectionViewContentInset
    }

    // MARK: - Action
    @IBAction func backButtonDidTap(_ sender: Any) {
        listener?.didSelectBack()
    }

    @IBAction func logoutButtonDidTap(_ sender: Any) {
        listener?.didSelectLogout()
    }
}

// MARK: - OpenDrivePresentable
extension OpenCloudViewController: OpenCloudPresentable {
    func bind(viewModel: OpenCloudViewModel) {
        self.loadViewIfNeeded()
        self.viewModel = viewModel
        self.titleLabel.text = viewModel.folderName()
        self.backLabel.text = viewModel.parentFolderName()
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension OpenCloudViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.numberOfSections() ?? 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItems(in: section) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            return self.reuseFolderCell(collectionView, indexPath: indexPath)
        } else {
            return self.reuseFileCell(collectionView, indexPath: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel!.item(at: indexPath.row, section: indexPath.section)
        if indexPath.section == 0 {
            listener?.didSelectFolder(viewModel: item)
            self.view.disableInteractiveFor(seconds: 0.5)
        } else {
            listener?.didSelectFile(itemViewModel: item)
        }
    }

    private func reuseFolderCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> CloudFolderCell {
        let cell = collectionView.dequeueCell(type: CloudFolderCell.self, indexPath: indexPath)!
        cell.bind(viewModel: viewModel!.item(at: indexPath.row, section: indexPath.section))
        return cell
    }

    private func reuseFileCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> CloudFileCell {
        let cell = collectionView.dequeueCell(type: CloudFileCell.self, indexPath: indexPath)!
        cell.bind(viewModel: viewModel!.item(at: indexPath.row, section: indexPath.section))
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OpenCloudViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? Const.lineSpacing : 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? Const.itemSpacing : 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthContentView = self.view.frame.width - collectionView.contentInset.left - collectionView.contentInset.right
        if indexPath.section == 0 {
            let width = (widthContentView - Const.itemSpacing * 2) / 3
            let height = width / 90 * 98
            return CGSize(width: width, height: height)
        }

        return CGSize(width: widthContentView, height: Const.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return viewModel?.contentInset(for: section) ?? .zero
    }
}

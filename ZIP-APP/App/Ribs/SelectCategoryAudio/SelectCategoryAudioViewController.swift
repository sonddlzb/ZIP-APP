//
//  SelectCategoryAudioViewController.swift
//  Zip
//
//

import RIBs
import RxSwift
import UIKit

private struct Const {
    static let cellSpacing: CGFloat = 3
    static let collectionViewContentInset: UIEdgeInsets = .init(top: 12, left: 3, bottom: 12, right: 3)
}

protocol SelectCategoryAudioPresentableListener: AnyObject {
    func didSelectBack()
    func didSelect(itemViewModel: SelectCategoryItemViewModel)
    func didSelectGrantAccess()
}

final class SelectCategoryAudioViewController: BaseViewControler, SelectCategoryAudioViewControllable {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!

    var viewModel: SelectCategoryViewModel?
    weak var listener: SelectCategoryAudioPresentableListener?

    private lazy var noPermissionView: SelectMediaNoPermissionView = {
        let view = SelectMediaNoPermissionView.loadView()
        view.delegate = self
        return view
    }()

    private lazy var noDataView: SelectMediaNoDataView = {
        let view = SelectMediaNoDataView.loadView()
        return view
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    override func viewWillDisappearByInteractive() {
        super.viewWillDisappearByInteractive()
        listener?.didSelectBack()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.setupCornerRadius(topLeftRadius: 0, topRightRadius: 25, bottomLeftRadius: 0, bottomRightRadius: 0)
    }

    // MARK: - Config
    private func config() {
        self.configCollectionView()
        self.configNoPermissionView()
        self.configNoDataView()
    }

    private func configCollectionView() {
        collectionView.registerCell(type: FolderDetailCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = Const.collectionViewContentInset
    }

    private func configNoPermissionView() {
        self.contentView.addSubview(self.noPermissionView)
        self.noPermissionView.fitSuperviewConstraint()
        self.noPermissionView.isHidden = true
    }

    private func configNoDataView() {
        self.contentView.addSubview(self.noDataView)
        self.noDataView.fitSuperviewConstraint()
        self.noDataView.isHidden = true
    }

    // MARK: - Action
    @IBAction func backButtonDidTap(_ sender: Any) {
        listener?.didSelectBack()
    }
}

// MARK: - SelectCategoryAudioPresentable
extension SelectCategoryAudioViewController: SelectCategoryAudioPresentable {
    func bind(viewModel: SelectCategoryViewModel) {
        self.loadViewIfNeeded()
        self.viewModel = viewModel

        self.collectionView.isHidden = viewModel.isEmpty()
        self.noDataView.isHidden = !viewModel.isEmpty()
        self.noPermissionView.isHidden = true

        self.collectionView.reloadData()
    }

    func displayNoPermission() {
        self.loadViewIfNeeded()
        self.noDataView.isHidden = true
        self.collectionView.isHidden = true
        self.noPermissionView.isHidden = false
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension SelectCategoryAudioViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItems() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(type: FolderDetailCell.self, indexPath: indexPath)!
        if let itemViewModel = self.viewModel?.item(at: indexPath.row) {
            cell.bind(itemViewModel: itemViewModel)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }

        listener?.didSelect(itemViewModel: viewModel.item(at: indexPath.row))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SelectCategoryAudioViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Const.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Const.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (UIScreen.main.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right - Const.cellSpacing * 2) / 3
        return CGSize(width: size, height: size)
    }
}

// MARK: - SelectMediaNoPermissionViewDelegate
extension SelectCategoryAudioViewController: SelectMediaNoPermissionViewDelegate {
    func selectMediaNoPermissionViewDidGrantAccess(_ view: SelectMediaNoPermissionView) {
        listener?.didSelectGrantAccess()
    }
}

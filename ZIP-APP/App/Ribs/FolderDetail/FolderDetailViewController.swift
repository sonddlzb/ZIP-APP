//
//  FolderDetailViewController.swift
//  Zip
//
//

import RIBs
import RxSwift
import UIKit
import DifferenceKit

private struct Const {
    static let cellSpacing: CGFloat = 3
    static let topCollectionViewContentInset: CGFloat = 12
    static let leftCollectionViewContentInset: CGFloat = 3
    static let rightCollectionViewContentInset: CGFloat = 3
    static let bottomCollectionViewContentInset: CGFloat = 12
    static let expandBottomCollectionViewContentInset: CGFloat = 60
}

protocol FolderDetailPresentableListener: AnyObject {
    func didLongPress(on itemViewModel: FolderDetailItemViewModel)
    func didPress(on itemViewModel: FolderDetailItemViewModel)
    func needSaveContentOffset(url: URL, contentOffsetY: CGFloat)
}

final class FolderDetailViewController: BaseViewControler {
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!

    weak var listener: FolderDetailPresentableListener?
    private var viewModel: FolderDetailViewModel?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.collectionView.registerCell(type: FolderDetailCell.self)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        self.view.layoutIfNeeded()

        self.collectionView.contentInset.top = Const.topCollectionViewContentInset
        self.collectionView.contentInset.left = Const.leftCollectionViewContentInset
        self.collectionView.contentInset.right = Const.rightCollectionViewContentInset
        self.collectionView.contentInset.bottom = Const.bottomCollectionViewContentInset + self.view.safeAreaInsets.bottom

        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(collectionViewDidLongPress(_:)))
        self.collectionView.addGestureRecognizer(longPressGesture)
    }

    // MARK: - Action
    @objc private func collectionViewDidLongPress(_ gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: self.collectionView)
        if let indexPath = collectionView.indexPathForItem(at: point),
           let itemViewModel = viewModel?.item(at: indexPath.row) {
            listener?.didLongPress(on: itemViewModel)
        }
    }

    // MARK: - Helper
    private func refreshSelectedState() {
        guard let viewModel = viewModel else {
            return
        }

        self.collectionView.indexPathsForVisibleItems.forEach { indexPath in
            let cell = collectionView.cellForItem(at: indexPath) as? FolderDetailCell
            cell?.bindSelectedState(itemViewModel: viewModel.item(at: indexPath.row))
        }
    }

    private func highlightItem(url: URL?) {
        guard let url = url,
              let index = self.viewModel?.index(url: url) else {
            return
        }

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if let cell = self.collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? FolderDetailCell {
                cell.highlight()
            }
        }

        self.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: [], animated: true)
        CATransaction.commit()
    }
}

// MARK: - FolderDetailPresentable
extension FolderDetailViewController: FolderDetailPresentable {
    func bind(viewModel: FolderDetailViewModel, highlightedItemURL: URL?) {
        self.loadViewIfNeeded()

        let source = self.viewModel?.listItemViewModels() ?? []
        let target = viewModel.listItemViewModels()
        let changeset = StagedChangeset(source: source, target: target)
        if changeset.isEmpty {
            self.viewModel = viewModel
            self.refreshSelectedState()
            self.highlightItem(url: highlightedItemURL)
            return
        }

        self.collectionView.reload(using: changeset) { _ in
            self.viewModel = viewModel
            self.highlightItem(url: highlightedItemURL)
        }

        DispatchQueue.main.async {
            if let contentOffsetY = viewModel.currentContentOffsetY(), highlightedItemURL == nil {
                self.collectionView.contentOffset.y = contentOffsetY
            }
        }
    }
}

// MARK: - FolderDetailViewControllable
extension FolderDetailViewController: FolderDetailViewControllable {
    func updateUIForOptionViewState(isVisible: Bool) {
        self.loadViewIfNeeded()
        self.view.layoutIfNeeded()
        let expansion = (isVisible ? Const.expandBottomCollectionViewContentInset + self.view.safeAreaInsets.bottom : 0)
        self.collectionView.contentInset.bottom = Const.bottomCollectionViewContentInset + expansion
    }

    func setBottomContentInset(_ bottom: CGFloat) {
        self.loadViewIfNeeded()
        self.collectionView.contentInset.bottom = bottom
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension FolderDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? FolderDetailCell,
           let viewModel = self.viewModel {
            cell.bindSelectedState(itemViewModel: viewModel.item(at: indexPath.row))
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let itemViewModel = viewModel?.item(at: indexPath.row) {
            listener?.didPress(on: itemViewModel)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FolderDetailViewController: UICollectionViewDelegateFlowLayout {
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

// MARK: - UIScrollViewDelegate
extension FolderDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let viewModel = self.viewModel {
            listener?.needSaveContentOffset(url: viewModel.url, contentOffsetY: scrollView.contentOffset.y)
        }
    }
}

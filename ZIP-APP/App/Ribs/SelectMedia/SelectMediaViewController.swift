//
//  SelectMediaViewController.swift
//  Zip
//
//  Created by đào sơn on 03/09/2022.
//

import Photos
import UIKit

import DifferenceKit
import RIBs
import RxSwift

// MARK: Constant
private struct Const {
    static let cellSpacing: CGFloat = 9
}

protocol SelectMediaPresentableListener: AnyObject {
    func didTapBackButton()
    func didTapSelectAllButton()
    func didPress(on itemViewModel: SelectMediaItemViewModel)
    func didUnselectAll()
    func didSelectOptionAction(_ action: OptionActionType)

    func didGrantAccessToLibrary()
    func didLongPressToPreview(asset: PHAsset)
    func applicationWillEnterForeground()
}

final class SelectMediaViewController: BaseViewControler, SelectMediaViewControllable {

    // MARK: Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var selectAllButton: TapableView!
    @IBOutlet private weak var mediaCollectionView: UICollectionView!
    @IBOutlet private weak var containerOptionView: UIView!
    @IBOutlet private weak var optionView: OptionView!
    @IBOutlet private weak var bottomContainerOptionViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var trailingCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var leadingCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var selectAllImageView: UIImageView!

    // MARK: Variables
    weak var listener: SelectMediaPresentableListener?
    private var selectMediaViewModel = SelectMediaViewModel.makeEmptyListAsset()

    private lazy var noDataView: SelectMediaNoDataView = {
        let view = SelectMediaNoDataView.loadView()
        return view
    }()

    private lazy var noPermissionView: SelectMediaNoPermissionView = {
        let view = SelectMediaNoPermissionView.loadView()
        return view
    }()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configMediaCollectionView()
        initBasicGUI()
        configOptionView()
        addNotificationObserver()
    }

    override func viewWillDisappearByInteractive() {
        super.viewWillDisappearByInteractive()
        listener?.didTapBackButton()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.contentView.setupCornerRadius(topLeftRadius: 0, topRightRadius: 25, bottomLeftRadius: 0, bottomRightRadius: 0)
    }

    func initBasicGUI() {
        initOtherCasesView()
    }

    func initOtherCasesView() {
        self.contentView.addSubview(self.noDataView)
        self.noDataView.fitSuperviewConstraint()
        self.contentView.addSubview(self.noPermissionView)
        self.noPermissionView.fitSuperviewConstraint()
        self.noPermissionView.delegate = self
    }

    func updateOtherCasesScreen() {
        let isHasNoData = (self.selectMediaViewModel.numberOfAsset() == 0)
        let isGrantedAccess = self.selectMediaViewModel.isGrantedAccess
        self.noDataView.isHidden = !isHasNoData
        self.noPermissionView.isHidden = isGrantedAccess
        self.selectAllButton.isHidden = isHasNoData || !isGrantedAccess
        self.titleLabel.text = selectMediaViewModel.titleContent()
    }

    func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForegroundNotification(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc func applicationWillEnterForegroundNotification(_ notification: Notification) {
        listener?.applicationWillEnterForeground()
    }

    // MARK: Config
    func configMediaCollectionView() {
        mediaCollectionView.showsVerticalScrollIndicator = false
        mediaCollectionView.showsHorizontalScrollIndicator = false
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        mediaCollectionView.registerCell(type: MediaCollectionViewCell.self)
    }

    func configOptionView() {
        optionView.delegate = self
        optionView.bind(viewModel: OptionViewModel(options: [.compress]))
        bottomContainerOptionViewConstraint.constant = -300
        containerOptionView.superview?.layoutIfNeeded()
    }

    // MARK: Action
    @IBAction func backButtonDidTap(_ sender: UIButton) {
        if self.selectMediaViewModel.isOnSelectedMode {
            listener?.didUnselectAll()
        } else {
            listener?.didTapBackButton()
        }
    }

    @IBAction func selectAllButtonDidTap(_ sender: Any) {
        listener?.didTapSelectAllButton()
    }

    // MARK: - Helper
    private func refreshSelectedState() {
        self.mediaCollectionView.indexPathsForVisibleItems.forEach { indexPath in
            let cell = self.mediaCollectionView.cellForItem(at: indexPath) as? MediaCollectionViewCell
            cell?.bindSelectedState(itemViewModel: self.selectMediaViewModel.item(at: indexPath.row))
        }
    }
}

// MARK: SelectMediaPresentable
extension SelectMediaViewController: SelectMediaPresentable {
    func bindMedia(viewModel: SelectMediaViewModel) {
        self.loadViewIfNeeded()

        let bindingBlock = {
            self.updateOtherCasesScreen()
            self.backButton.setImage(viewModel.backButtonImage(), for: .normal)
            self.selectAllImageView.image = viewModel.selectAllImage()
            UIView.animate(withDuration: 0.25) {
                if viewModel.isOptionViewVisible() {
                    self.bottomContainerOptionViewConstraint.constant = 0
                    self.bottomCollectionViewConstraint.constant = self.containerOptionView.frame.height
                } else {
                    self.bottomContainerOptionViewConstraint.constant = -300
                    self.bottomCollectionViewConstraint.constant = 0
                }

               self.containerOptionView.superview?.layoutIfNeeded()
            }
        }

        let source = self.selectMediaViewModel.listItemViewModel()
        let target = viewModel.listItemViewModel()
        let changeset = StagedChangeset(source: source, target: target)

        if changeset.isEmpty {
            self.selectMediaViewModel = viewModel
            self.refreshSelectedState()
            bindingBlock()
        } else {
            self.mediaCollectionView.reload(using: changeset) { _ in
                self.selectMediaViewModel = viewModel
                bindingBlock()
            }
        }
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension SelectMediaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectMediaViewModel.numberOfAsset()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mediaCollectionView.dequeueCell(type: MediaCollectionViewCell.self, indexPath: indexPath)!
        let itemViewModel = selectMediaViewModel.item(at: indexPath.row)
        cell.delegate = self
        cell.bind(viewModel: itemViewModel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? MediaCollectionViewCell {
            cell.bindSelectedState(itemViewModel: self.selectMediaViewModel.item(at: indexPath.row))
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        listener?.didPress(on: selectMediaViewModel.item(at: indexPath.row))
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension SelectMediaViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Const.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Const.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (UIScreen.main.bounds.width - leadingCollectionViewConstraint.constant - trailingCollectionViewConstraint.constant - collectionView.contentInset.left - collectionView.contentInset.right - Const.cellSpacing * 2) / 3
        return CGSize(width: size, height: size)
    }
}

// MARK: OptionViewDelegate
extension SelectMediaViewController: OptionViewDelegate {
    func optionView(_ view: OptionView, didSelectAction action: OptionActionType) {
        listener?.didSelectOptionAction(action)
    }
}

// MARK: SelectMediaNoPermissionViewDelegate
extension SelectMediaViewController: SelectMediaNoPermissionViewDelegate {
    func selectMediaNoPermissionViewDidGrantAccess(_ view: SelectMediaNoPermissionView) {
        listener?.didGrantAccessToLibrary()
    }
}

// MARK: MediaCollectionViewCellDelegate
extension SelectMediaViewController: MediaCollectionViewCellDelegate {
    func mediaCollectionViewCell(didLongPressAt cell: MediaCollectionViewCell) {
        if let indexPath = self.mediaCollectionView.indexPath(for: cell) {
            listener?.didLongPressToPreview(asset: self.selectMediaViewModel.listAsset[indexPath.row])
        }
    }
}

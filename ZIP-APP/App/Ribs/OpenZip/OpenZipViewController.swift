//
//  OpenZipViewController.swift
//  Zip
//
//

import RIBs
import RxSwift
import UIKit

private struct Const {
    static let cellSpacing: CGFloat = 3
    static let topCollectionViewContentInset: CGFloat = 12
    static let leftCollectionViewContentInset: CGFloat = 3
    static let rightCollectionViewContentInset: CGFloat = 3
    static let bottomCollectionViewContentInset: CGFloat = 12
}

protocol OpenZipPresentableListener: AnyObject {
    func didSelectBack()
    func didSelectExtract()
}

final class OpenZipViewController: BaseViewControler, OpenZipViewControllable {

    // MARK: Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var optionView: OptionView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var containerOptionView: UIView!
    @IBOutlet private weak var backImageView: UIImageView!
    @IBOutlet private weak var backButton: ExtensibleTouchView!

    // MARK: Variables
    weak var listener: OpenZipPresentableListener?
    var viewModel: OpenZipViewModel?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()

        self.contentView.setupCornerRadius(topLeftRadius: 0, topRightRadius: 25, bottomLeftRadius: 0, bottomRightRadius: 0)

        self.collectionView.contentInset.bottom = Const.bottomCollectionViewContentInset + (self.view.frame.height - self.containerOptionView.frame.origin.y)
    }

    override func viewWillDisappearByInteractive() {
        super.viewWillDisappearByInteractive()
        listener?.didSelectBack()
    }

    // MARK: - Config
    private func config() {
        self.configCollectionView()
        self.configOptionView()
        self.configBackButton()
    }

    private func configBackButton() {
        let backButtonGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonDidTap(_:)))
        self.backButton.addGestureRecognizer(backButtonGesture)
    }

    private func configOptionView() {
        optionView.delegate = self
        optionView.bind(viewModel: OptionViewModel(options: [.extract]))
    }

    private func configCollectionView() {
        self.collectionView.registerCell(type: OpenZipCell.self)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.contentInset.top = Const.topCollectionViewContentInset
        self.collectionView.contentInset.left = Const.leftCollectionViewContentInset
        self.collectionView.contentInset.right = Const.rightCollectionViewContentInset
    }

    // MARK: - Action
    @objc func backButtonDidTap(_ sender: Any) {
        listener?.didSelectBack()
    }
}

// MARK: - OpenZipPresentable
extension OpenZipViewController: OpenZipPresentable {
    func bind(viewModel: OpenZipViewModel) {
        self.loadViewIfNeeded()
        self.viewModel = viewModel
        self.collectionView.reloadData()
        self.titleLabel.text = viewModel.name()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension OpenZipViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItems() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(type: OpenZipCell.self, indexPath: indexPath)!
        if let itemViewModel = self.viewModel?.item(at: indexPath.row) {
            cell.bind(itemViewModel: itemViewModel)
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OpenZipViewController: UICollectionViewDelegateFlowLayout {
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

// MARK: - OptionViewDelegate
extension OpenZipViewController: OptionViewDelegate {
    func optionView(_ view: OptionView, didSelectAction action: OptionActionType) {
        listener?.didSelectExtract()
    }
}

//
//  OptionView.swift
//  Zip
//
//

import UIKit
import DifferenceKit

private struct Const {
    static let leftCollectionViewSectionInset: CGFloat = 30
    static let rightCollectionViewSectionInset: CGFloat = 30
}

protocol OptionViewDelegate: AnyObject {
    func optionView(_ view: OptionView, didSelectAction action: OptionActionType)
}

class OptionView: UIView {
    weak var delegate: OptionViewDelegate?

    private lazy var backgroundImageView: UIImageView = {
        let image = UIImage(named: "bg_option_view")!
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var bottomSafeAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0x283244)
        return view
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var backButton: TapableView = {
        let view = TapableView()
        view.isHidden = true
        view.addTarget(self, action: #selector(backButtonDidTap(_:)), for: .touchUpInside)

        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(rgb: 0x6F7481).withAlphaComponent(0.5)
        backgroundView.isUserInteractionEnabled = false
        view.addSubview(backgroundView)
        backgroundView.fitSuperviewConstraint()

        let image = UIImage(named: "ic_back")!
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        return view
    }()

    private var collectionView: UICollectionView!
    private var viewModel = OptionViewModel.makeEmpty()

    // MARK: - Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.config()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.config()
    }

    // MARK: - Override
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backButton.layoutIfNeeded()
        self.backButton.setupCornerRadius(topLeftRadius: 11, topRightRadius: 5, bottomLeftRadius: 5, bottomRightRadius: 5)
    }

    // MARK: - Config
    private func config() {
        self.configCollectionView()

        self.addSubview(self.bottomSafeAreaView)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.backgroundImageView)
        self.contentView.addSubview(self.collectionView)
        self.contentView.addSubview(self.backButton)

        self.backgroundImageView.fitSuperviewConstraint()
        self.collectionView.fitSuperviewConstraint()

        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        self.bottomSafeAreaView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.bottomSafeAreaView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.bottomSafeAreaView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.bottomSafeAreaView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.bottomSafeAreaView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),

            self.contentView.bottomAnchor.constraint(equalTo: self.bottomSafeAreaView.topAnchor),
            self.contentView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.contentView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor),

            self.backButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            self.backButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            self.backButton.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5),
            self.backButton.widthAnchor.constraint(equalTo: self.backButton.heightAnchor, multiplier: 21.0/39.0)
        ])
    }

    private func configCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal

        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), collectionViewLayout: flowLayout)
        self.collectionView.registerCell(type: OptionItemCell.self)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.isScrollEnabled = false
        self.collectionView.backgroundColor = .clear
    }

    // MARK: - Action
    @objc private func backButtonDidTap(_ sender: TapableView) {
        self.scrollToFirstPage()
    }

    // MARK: - Public method
    func bind(viewModel: OptionViewModel) {
        let oldViewModel = self.viewModel
        Set(viewModel.options.map({ $0.priority() })).forEach { priority in
            let source = oldViewModel.options.filter({ $0.priority() == priority })
            let target = viewModel.options.filter({ $0.priority() == priority })
            let changeset = StagedChangeset(source: source, target: target, section: priority)
            if changeset.isEmpty {
                return
            }

            self.collectionView.reload(using: changeset) { _ in
                self.viewModel = viewModel
            }
        }
    }

    // MARK: - Helper
    func scrollToFirstPage() {
        if !self.viewModel.isEmpty() {
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension OptionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel.numberOfPage()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(type: OptionItemCell.self, indexPath: indexPath)!
        cell.delegate = self
        cell.bind(viewModel: viewModel.item(at: indexPath.row, page: indexPath.section))
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OptionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.insetForSection(section)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = self.frame.height
        let insets = self.insetForSection(indexPath.section)
        let width = (UIScreen.main.bounds.width - insets.left - insets.right) / CGFloat(viewModel.numberOfItems(in: indexPath.section))
        return CGSize(width: width, height: height)
    }

    private func insetForSection(_ section: Int) -> UIEdgeInsets {
        return section == 0 ? .zero : UIEdgeInsets(top: 0, left: Const.leftCollectionViewSectionInset, bottom: 0, right: Const.rightCollectionViewSectionInset)
    }
}

// MARK: - OptionItemCellDelegate
extension OptionView: OptionItemCellDelegate {
    func optionItemCellDidSelected(_ cell: OptionItemCell) {
        if cell.viewModel.actionType == .more {
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 1), at: .left, animated: true)
        } else {
            delegate?.optionView(self, didSelectAction: cell.viewModel.actionType)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension OptionView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.backButton.isHidden = scrollView.contentOffset.x < UIScreen.main.bounds.width
    }
}

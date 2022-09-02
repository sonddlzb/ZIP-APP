//
//  SelectDestinationNavigationView.swift
//  Zip
//
//

import UIKit

protocol SelectDestinationNavigationViewDelegate: AnyObject {
    func selectDestinationNavigationView(_ navigationView: SelectDestinationNavigationView, didRouteToURL url: URL)
}

class SelectDestinationNavigationView: UIView {
    weak var delegate: SelectDestinationNavigationViewDelegate?

    private var viewModel: SelectDestinationNavigationViewModel!

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private lazy var contentScrollView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    // MARK: - Common init
    private func commonInit() {
        self.addSubview(scrollView)
        self.scrollView.addSubview(contentScrollView)

        self.scrollView.fitSuperviewConstraint()
        self.contentScrollView.fitSuperviewConstraint()
        self.contentScrollView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
    }

    // MARK: - Action
    @objc private func itemViewDidTap(_ sender: SelectDestinationNavigationItemView) {
        let selectedURL = self.viewModel.url(at: sender.tag)
        if selectedURL == self.viewModel.url {
            return
        }

        self.bind(url: selectedURL)
        delegate?.selectDestinationNavigationView(self, didRouteToURL: selectedURL)
    }

    // MARK: - Public method
    func bind(url: URL) {
        self.viewModel = SelectDestinationNavigationViewModel(url: url)
        self.buildContentScrollView()
        self.scrollView.layoutIfNeeded()
        if let lastItem = self.contentScrollView.arrangedSubviews.last {
            self.scrollView.scrollRectToVisible(lastItem.frame, animated: true)
        }
    }

    // MARK: - Helper
    private func buildContentScrollView() {
        self.contentScrollView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        for index in 0 ..< self.viewModel.numberOfComponents() {
            let item = SelectDestinationNavigationItemView()
            item.tag = index
            item.setText(self.viewModel.text(at: index))
            item.unselect()
            item.addTarget(self, action: #selector(itemViewDidTap(_:)), for: .touchUpInside)
            item.translatesAutoresizingMaskIntoConstraints = false
            self.contentScrollView.addArrangedSubview(item)

            NSLayoutConstraint.activate([
                item.topAnchor.constraint(equalTo: self.contentScrollView.topAnchor),
                item.bottomAnchor.constraint(equalTo: self.contentScrollView.bottomAnchor)
            ])
        }

        (self.contentScrollView.arrangedSubviews.last as? SelectDestinationNavigationItemView)?.select()
    }
}

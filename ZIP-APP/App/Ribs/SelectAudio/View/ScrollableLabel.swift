//
//  ScrollableLabel.swift
//  Zip
//
//

import UIKit

private struct Const {
    static let pageSpacing: CGFloat = 50
}

class ScrollableLabel: UIView {
    var text: String {
        get {
            self.firstPageLabel.text ?? ""
        }

        set {
            self.firstPageLabel.text = newValue
            self.secondPageLabel.text = newValue
            UIView.performWithoutAnimation {
                self.firstPageLabel.sizeToFit()
                self.secondPageLabel.sizeToFit()
            }
        }
    }

    // MARK: - UI
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()

    private lazy var contentScrollView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var firstPageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(rgb: 0x0D2020)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var secondPageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(rgb: 0x0D2020)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    // MARK: - Variables
    private var timer: Timer?

    // MARK: - Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    // MARK: - Common init
    private func commonInit() {
        self.addSubview(scrollView)
        self.scrollView.addSubview(self.contentScrollView)
        self.contentScrollView.addSubview(self.firstPageLabel)
        self.contentScrollView.addSubview(self.secondPageLabel)

        self.scrollView.fitSuperviewConstraint()
        self.contentScrollView.fitSuperviewConstraint()

        NSLayoutConstraint.activate([
            self.firstPageLabel.leftAnchor.constraint(equalTo: self.contentScrollView.leftAnchor),
            self.firstPageLabel.topAnchor.constraint(equalTo: self.contentScrollView.topAnchor),
            self.firstPageLabel.bottomAnchor.constraint(equalTo: self.contentScrollView.bottomAnchor),

            self.firstPageLabel.rightAnchor.constraint(equalTo: self.secondPageLabel.leftAnchor, constant: -Const.pageSpacing),
            self.secondPageLabel.topAnchor.constraint(equalTo: self.contentScrollView.topAnchor),
            self.secondPageLabel.bottomAnchor.constraint(equalTo: self.contentScrollView.bottomAnchor),
            self.secondPageLabel.rightAnchor.constraint(equalTo: self.contentScrollView.rightAnchor)
        ])

        self.contentScrollView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor).isActive = true
    }

    // MARK: - Public method
    func startAnimation() {
        guard canScroll() else {
            return
        }

        timer?.invalidate()
        self.secondPageLabel.isHidden = false
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }

            self.scrollView.contentOffset.x += 1
            if self.scrollView.contentOffset.x >= self.secondPageLabel.frame.minX {
                self.scrollView.contentOffset.x = self.firstPageLabel.frame.minX
            }
        })
    }

    func stopAnimation() {
        guard canScroll() else {
            return
        }

        timer?.invalidate()
        timer = nil
        self.secondPageLabel.isHidden = true
        self.scrollView.contentOffset.x = -self.scrollView.contentInset.left
    }

    // MARK: - Helper
    private func canScroll() -> Bool {
        return self.firstPageLabel.frame.width > self.scrollView.frame.width
    }
}

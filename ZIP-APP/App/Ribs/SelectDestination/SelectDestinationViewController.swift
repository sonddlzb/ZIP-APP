//
//  SelectDestinationViewController.swift
//  Zip
//
//

import RIBs
import RxSwift
import UIKit

protocol SelectDestinationPresentableListener: AnyObject {
    func didSelectMoveHere()
    func didSelectClose()
    func didSelectCreateNewFolder()
    func didSelectRouteTo(url: URL)
    func needReloadFolderDetail(url: URL)
    func setBottomContentInsetForContentView(_ bottom: CGFloat)
}

final class SelectDestinationViewController: BaseViewControler {
    // MARK: - Outlets
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var navigationView: SelectDestinationNavigationView!
    @IBOutlet private weak var moveHereButton: TapableView!

    // MARK: - Variables
    weak var listener: SelectDestinationPresentableListener?
    private var currentViewController: ViewControllable?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    override func viewWillDisappearByInteractive() {
        super.viewWillDisappearByInteractive()
        listener?.didSelectClose()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.contentView.layoutIfNeeded()
        self.contentView.setupCornerRadius(topLeftRadius: 0, topRightRadius: 25, bottomLeftRadius: 0, bottomRightRadius: 0)

        self.view.layoutIfNeeded()
        listener?.setBottomContentInsetForContentView(self.view.frame.height - moveHereButton.frame.origin.y + 20 - self.view.safeAreaInsets.bottom)
    }

    // MARK: - Config
    private func config() {
        self.navigationView.delegate = self
    }

    // MARK: - Action
    @IBAction func moveHereButtonDidTap(_ sender: Any) {
        listener?.didSelectMoveHere()
    }

    @IBAction func createNewFolderButtonDidTap(_ sender: Any) {
        listener?.didSelectCreateNewFolder()
    }

    @IBAction func closeButtonDidTap(_ sender: Any) {
        listener?.didSelectClose()
    }
}

// MARK: - SelectDestinationPresentable
extension SelectDestinationViewController: SelectDestinationPresentable {
    func bind(viewModel: SelectDestinationNavigationViewModel) {
        self.loadViewIfNeeded()
        self.navigationView.bind(url: viewModel.url)
        if self.currentViewController != nil {
            self.listener?.needReloadFolderDetail(url: viewModel.url)
        }
    }
}

// MARK: - SelectDestinationViewControllable
extension SelectDestinationViewController: SelectDestinationViewControllable {
    func embedViewController(_ viewController: ViewControllable) {
        self.loadViewIfNeeded()
        self.currentViewController?.uiviewController.view.removeFromSuperview()
        self.currentViewController?.uiviewController.removeFromParent()

        guard let embededView = viewController.uiviewController.view else {
            return
        }

        self.contentView.addSubview(embededView)
        self.addChild(viewController.uiviewController)

        embededView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            embededView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            embededView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            embededView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            embededView.topAnchor.constraint(equalTo: self.navigationView.bottomAnchor)
        ])

        self.currentViewController = viewController
        self.view.layoutIfNeeded()
    }
}

// MARK: - SelectDestinationNavigationViewDelegate
extension SelectDestinationViewController: SelectDestinationNavigationViewDelegate {
    func selectDestinationNavigationView(_ navigationView: SelectDestinationNavigationView, didRouteToURL url: URL) {
        listener?.didSelectRouteTo(url: url)
    }
}

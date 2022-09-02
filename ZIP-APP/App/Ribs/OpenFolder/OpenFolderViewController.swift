//
//  OpenFolderViewController.swift
//  ZIP-APP
//
//

import RIBs
import RxSwift
import UIKit

private struct Const {
    static let rightAddButtonConstant: CGFloat = 20
}

protocol OpenFolderPresentableListener: AnyObject {
    func didSelectAddFileFromPhoto()
    func didSelectAddFileFromAudio()
    func didSelectAddFileFromDocumentBrowser()
    func didSelectAddFileFromGoogleDrive()
    func didSelectAddFileFromOnedrive()
    func didSelectAddFileFromDropbox()
    func didSelectBack()
    func didSelectCreateNewFolder()
    func didSelectAll()
    func didUnselectAll()
    func didDisableSelectingMode()
    func didUpdateOptionViewState(isVisible: Bool)
    func didSelectAddFile()
    func didSelectOptionAction(_ action: OptionActionType)
    func didSelectDeleteOnDialog()

    func needReloadFolderDetail(url: URL)
    func updateBottomContentInset(_ value: CGFloat)
}

final class OpenFolderViewController: BaseViewControler {
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var newFolderButton: UIButton!
    @IBOutlet private weak var selectAllImageView: UIImageView!
    @IBOutlet private weak var addFileButton: TapableView!
    @IBOutlet private weak var selectAllButton: TapableView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var containerOptionView: UIView!
    @IBOutlet private weak var optionView: OptionView!
    @IBOutlet private weak var bottomContainerOptionViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var rightAddButtonConstraint: NSLayoutConstraint!
    @IBOutlet private weak var backButton: ExtensibleTouchView!
    @IBOutlet private weak var backImageView: UIImageView!

    // MARK: - Variables
    weak var listener: OpenFolderPresentableListener?
    private var viewModel: OpenFolderViewModel!
    private var currentViewController: ViewControllable?
    private lazy var noDataView: OpenFolderNoDataView = {
        let view = OpenFolderNoDataView.loadView()
        view.delegate = self
        return view
    }()

    override var isInteractivePopGestureEnabled: Bool {
        return false
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()

        self.contentView.setupCornerRadius(topLeftRadius: 0, topRightRadius: 25, bottomLeftRadius: 0, bottomRightRadius: 0)
        listener?.updateBottomContentInset(self.view.frame.height - self.addFileButton.frame.origin.y - self.view.safeAreaInsets.bottom + 20)
    }

    // MARK: - Config
    private func config() {
        self.configOptionView()

        self.selectAllButton.isHidden = true
        self.newFolderButton.isHidden = false

        self.contentView.addSubview(self.noDataView)
        self.noDataView.fitSuperviewConstraint()

        let backButtonGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonDidTap(_:)))
        self.backButton.addGestureRecognizer(backButtonGesture)
    }

    private func configOptionView() {
        optionView.delegate = self
        optionView.bind(viewModel: OptionViewModel(options: [.extract, .compress, .move, .more, .rename, .share, .delete])) // test options
        bottomContainerOptionViewConstraint.constant = -300
        containerOptionView.superview?.layoutIfNeeded()
    }

    // MARK: - Action
    @objc func backButtonDidTap(_ sender: Any) {
        if self.viewModel.isSelectingModeEnabled {
            listener?.didDisableSelectingMode()
        } else {
            listener?.didSelectBack()
        }
    }

    @IBAction func newFolderButtonDidTap(_ sender: Any) {
        listener?.didSelectCreateNewFolder()
    }

    @IBAction func selectAllButtonDidTap(_ sender: Any) {
        listener?.didSelectAll()
    }

    @IBAction func addButtonDidTap(_ sender: Any) {
        listener?.didSelectAddFile()
    }
}

// MARK: - OpenFolderPresentable
extension OpenFolderViewController: OpenFolderPresentable {
    func bind(viewModel: OpenFolderViewModel) {
        self.loadViewIfNeeded()
        self.viewModel = viewModel
        self.noDataView.isHidden = !viewModel.isEmpty()
        self.addFileButton.isHidden = !self.noDataView.isHidden
        self.currentViewController?.uiviewController.view.isHidden = viewModel.isEmpty()

        self.titleLabel.text = viewModel.title()
        self.titleLabel.textAlignment = viewModel.titleAlignment()

        self.backImageView.image = self.viewModel.backButtonImage()

        self.optionView.bind(viewModel: OptionViewModel(options: viewModel.getOptions()))
        UIView.animate(withDuration: 0.25) {
            self.bottomContainerOptionViewConstraint.constant = viewModel.isOptionViewVisible() ? 0 : -300
            self.rightAddButtonConstraint.constant = viewModel.isSelectedModeOn() ? -300 : Const.rightAddButtonConstant
            self.view.layoutIfNeeded()
        } completion: { _ in
            if !viewModel.isSelectedModeOn() {
                self.optionView.scrollToFirstPage()
            }
        }

        self.selectAllImageView.image = viewModel.selectAllImage()
        self.selectAllButton.isHidden = !viewModel.isSelectedModeOn()
        self.newFolderButton.isHidden = !self.selectAllButton.isHidden

        if !viewModel.isEmpty() && self.currentViewController != nil {
            listener?.needReloadFolderDetail(url: viewModel.url)
        }
    }

    func displayDeleteDialog(viewModel: OpenFolderViewModel) {
        YesNoDialog.show(title: viewModel.titleDeleteDialog(), message: viewModel.messageDeleteDialog(), actionType: .delete, action: { [weak self] in
            self?.listener?.didSelectDeleteOnDialog()
        })
    }
}

// MARK: - OpenFolderViewControllable
extension OpenFolderViewController: OpenFolderViewControllable {
    func embedViewController(_ viewController: ViewControllable) {
        self.loadViewIfNeeded()
        self.currentViewController?.uiviewController.view.removeFromSuperview()
        self.currentViewController?.uiviewController.removeFromParent()

        self.contentView.addSubview(viewController.uiviewController.view)
        viewController.uiviewController.view.fitSuperviewConstraint()
        self.addChild(viewController.uiviewController)

        self.currentViewController = viewController
        viewController.uiviewController.view.isHidden = self.viewModel.isEmpty()
    }
}

// MARK: - OpenFolderNoDataViewDelegate
extension OpenFolderViewController: OpenFolderNoDataViewDelegate {
    func addFileMenuViewDidSelectPhoto(_ view: AddFileMenuView) {
        listener?.didSelectAddFileFromPhoto()
    }

    func addFileMenuViewDidSelectAudio(_ view: AddFileMenuView) {
        listener?.didSelectAddFileFromAudio()
    }

    func addFileMenuViewDidSelectDocumentBrowser(_ view: AddFileMenuView) {
        listener?.didSelectAddFileFromDocumentBrowser()
    }

    func addFileMenuViewDidSelectGoogleDrive(_ view: AddFileMenuView) {
        listener?.didSelectAddFileFromGoogleDrive()
    }

    func addFileMenuViewDidSelectOnedrive(_ view: AddFileMenuView) {
        listener?.didSelectAddFileFromOnedrive()
    }

    func addFileMenuViewDidSelectDropbox(_ view: AddFileMenuView) {
        listener?.didSelectAddFileFromDropbox()
    }
}

// MARK: - OptionViewDelegate
extension OpenFolderViewController: OptionViewDelegate {
    func optionView(_ view: OptionView, didSelectAction action: OptionActionType) {
        listener?.didSelectOptionAction(action)
    }
}

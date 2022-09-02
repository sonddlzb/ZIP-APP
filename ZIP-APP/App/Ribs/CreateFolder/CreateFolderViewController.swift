//
//  CreateFolderViewController.swift
//  Zip
//
//

import RIBs
import RxSwift
import UIKit

protocol CreateFolderPresentableListener: AnyObject {
    func didSelectCancel()
    func didSelectOK(name: String)
}

final class CreateFolderViewController: BaseViewControler, CreateFolderViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var bottomBackgroundViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerInputTextFragment: UIView!

    // MARK: - Variables
    weak var listener: CreateFolderPresentableListener?
    private var viewModel: CreateFolderViewModel?
    private var blurView: SolarBlurView!

    private lazy var inputTextFragment: InputTextFragment = {
        let inputTextFragment = InputTextFragment.loadView()
        inputTextFragment.delegate = self
        inputTextFragment.placeholder = viewModel?.placeholder()
        inputTextFragment.title = viewModel?.title() ?? ""
        return inputTextFragment
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
        self.inputTextFragment.text = "New folder"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.blurView.setupBlurAnimator()
            self.inputTextFragment.becomeFirstResponder()
        }
    }

    // MARK: - Config
    private func config() {
        self.configBlurView()
        self.configInputTextFragment()
    }

    private func configBlurView() {
        self.blurView = SolarBlurView()
        self.view.insertSubview(self.blurView, at: 0)
        self.blurView.fitSuperviewConstraint()
    }

    private func configInputTextFragment() {
        self.containerInputTextFragment.addSubview(self.inputTextFragment)
        self.inputTextFragment.fitSuperviewConstraint()
    }
}

// MARK: - CreateFolderPresentable
extension CreateFolderViewController: CreateFolderPresentable {
    func bind(viewModel: CreateFolderViewModel) {
        self.loadViewIfNeeded()
        self.viewModel = viewModel
        self.inputTextFragment.placeholder = viewModel.placeholder()
        self.inputTextFragment.title = viewModel.title()
    }
}

// MARK: - InputTextFragmentDelegate
extension CreateFolderViewController: InputTextFragmentDelegate {
    func inputTextFragmentDidSelectCancel(_ fragment: InputTextFragment) {
        listener?.didSelectCancel()
    }

    func inputTextFragment(_ fragment: InputTextFragment, didSelectOK text: String) {
        listener?.didSelectOK(name: text)
    }

    func inputTextFragment(_ fragment: InputTextFragment, shouldChangeTextTo text: String) -> Bool {
        return !text.trim().isEmpty
    }

    func inputTextFragment(_ fragment: InputTextFragment, willShowKeyboard keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 0.25) {
            self.bottomBackgroundViewConstraint.constant = keyboardHeight
            self.view.layoutIfNeeded()
        }
    }

    func inputTextFragment(_ fragment: InputTextFragment, willHideKeyboard keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 0.25) {
            self.bottomBackgroundViewConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}

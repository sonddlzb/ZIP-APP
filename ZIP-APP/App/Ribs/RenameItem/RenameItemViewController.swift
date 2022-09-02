//
//  RenameItemViewController.swift
//  Zip
//
//

import RIBs
import RxSwift
import UIKit

protocol RenameItemPresentableListener: AnyObject {
    func didSelectCancel()
    func didSelectOK(name: String)
    func isExistedName(name: String) -> Bool
}

final class RenameItemViewController: BaseViewControler, RenameItemViewControllable {
    @IBOutlet weak var containerInputTextFragment: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottomContainerViewConstraint: NSLayoutConstraint!

    weak var listener: RenameItemPresentableListener?
    private var viewModel: RenameItemViewModel?
    private var blurView: SolarBlurView!

    private lazy var inputTextFragment: InputTextFragment = {
        let inputTextFragment = InputTextFragment.loadView()
        inputTextFragment.delegate = self
        inputTextFragment.text = viewModel?.name() ?? ""
        inputTextFragment.placeholder = viewModel?.placeholderForTextfield()
        inputTextFragment.title = viewModel?.title() ?? ""
        return inputTextFragment
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.blurView.setupBlurAnimator()
            self.inputTextFragment.becomeFirstResponder()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.inputTextFragment.becomeFirstResponder()
    }

    // MARK: - Config
    private func config() {
        self.configInputTextFragment()
        self.configBlurView()
    }

    private func configInputTextFragment() {
        self.containerInputTextFragment.addSubview(self.inputTextFragment)
        self.inputTextFragment.fitSuperviewConstraint()
    }

    private func configBlurView() {
        self.blurView = SolarBlurView()
        self.view.insertSubview(blurView, at: 0)
        self.blurView.fitSuperviewConstraint()
    }

    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.first?.view == self.containerView {
            self.inputTextFragment.endEditing(true)
        }
    }
}

// MARK: - RenameItemPresentable
extension RenameItemViewController: RenameItemPresentable {
    func bind(viewModel: RenameItemViewModel) {
        self.loadViewIfNeeded()
        self.viewModel = viewModel
        self.inputTextFragment.text = viewModel.name()
        self.inputTextFragment.placeholder = viewModel.placeholderForTextfield()
        self.inputTextFragment.title = viewModel.title()
    }
}

// MARK: - InputTextFragmentDelegate
extension RenameItemViewController: InputTextFragmentDelegate {
    func inputTextFragmentDidSelectCancel(_ fragment: InputTextFragment) {
        listener?.didSelectCancel()
    }

    func inputTextFragment(_ fragment: InputTextFragment, didSelectOK text: String) {
        listener?.didSelectOK(name: text)
    }

    func inputTextFragment(_ fragment: InputTextFragment, shouldChangeTextTo text: String) -> Bool {
        return text != viewModel?.name() && !text.trim().isEmpty
    }

    func inputTextFragment(_ fragment: InputTextFragment, willShowKeyboard keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 0.25) {
            self.bottomContainerViewConstraint.constant = keyboardHeight
            self.view.layoutIfNeeded()
        }
    }

    func inputTextFragment(_ fragment: InputTextFragment, willHideKeyboard keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 0.25) {
            self.bottomContainerViewConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}

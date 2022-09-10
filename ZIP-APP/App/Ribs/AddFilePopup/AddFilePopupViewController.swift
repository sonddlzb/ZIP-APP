//
//  AddFilePopupViewController.swift
//  Zip
//
//

import RIBs
import RxSwift
import UIKit

protocol AddFilePopupPresentableListener: AnyObject {
    func didSelectAddFileFromPhoto()
    func didSelectAddFileFromAudio()
    func didSelectAddFileFromDocumentBrowser()
    func didSelectAddFileFromGoogleDrive()
    func didSelectAddFileFromOneDrive()
    func didSelectAddFileFromDropbox()
    func didSelectClose()
}

final class AddFilePopupViewController: BaseViewControler, AddFilePopupPresentable, AddFilePopupViewControllable {
    @IBOutlet private weak var blurView: SolarBlurView!
    @IBOutlet private weak var containerAddFileMenuView: UIView!
    @IBOutlet private weak var bottomContainerAddFileMenuViewConstraint: NSLayoutConstraint!

    weak var listener: AddFilePopupPresentableListener?

    private lazy var addFileMenuView: AddFileMenuView = {
        let view = AddFileMenuView.loadView()
        view.delegate = self
        return view
    }()

    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.first?.view == self.view {
            self.animateDismissing {
                self.listener?.didSelectClose()
            }
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.blurView.setupBlurAnimator()
            self.animateShowing()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.containerAddFileMenuView.setupCornerRadius(topLeftRadius: 40, topRightRadius: 40, bottomLeftRadius: 0, bottomRightRadius: 0)
    }

    // MARK: - Config
    private func config() {
        self.containerAddFileMenuView.addSubview(addFileMenuView)
        self.addFileMenuView.fitSuperviewConstraint()

        self.blurView.alpha = 0
        self.bottomContainerAddFileMenuViewConstraint.constant = -400
        self.view.layoutIfNeeded()
        self.view.isUserInteractionEnabled = false
    }

    // MARK: - Helper
    private func animateShowing() {
        UIView.animate(withDuration: 0.25) {
            self.blurView.alpha = 1
            self.bottomContainerAddFileMenuViewConstraint.constant = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.view.isUserInteractionEnabled = true
        }
    }

    private func animateDismissing(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.25) {
            self.blurView.alpha = 0
            self.bottomContainerAddFileMenuViewConstraint.constant = -400
            self.view.layoutIfNeeded()
        } completion: { _ in
            completion?()
        }
    }
}

// MARK: - AddFileMenuViewDelegate
extension AddFilePopupViewController: AddFileMenuViewDelegate {
    func addFileMenuViewDidSelectPhoto(_ view: AddFileMenuView) {
        self.animateDismissing {
            self.listener?.didSelectAddFileFromPhoto()
        }
    }

    func addFileMenuViewDidSelectAudio(_ view: AddFileMenuView) {
        self.animateDismissing {
            self.listener?.didSelectAddFileFromAudio()
        }
    }

    func addFileMenuViewDidSelectDocumentBrowser(_ view: AddFileMenuView) {
        self.animateDismissing {
            self.listener?.didSelectAddFileFromDocumentBrowser()
        }
    }

    func addFileMenuViewDidSelectGoogleDrive(_ view: AddFileMenuView) {
        self.animateDismissing {
            self.listener?.didSelectAddFileFromGoogleDrive()
        }
    }

    func addFileMenuViewDidSelectOnedrive(_ view: AddFileMenuView) {
        self.animateDismissing {
            self.listener?.didSelectAddFileFromOneDrive()
        }
    }

    func addFileMenuViewDidSelectDropbox(_ view: AddFileMenuView) {
        self.animateDismissing {
            self.listener?.didSelectAddFileFromDropbox()
        }
    }
}

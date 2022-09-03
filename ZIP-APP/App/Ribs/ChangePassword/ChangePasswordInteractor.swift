//
//  ChangePasswordInteractor.swift
//  Zip
//
//  Created by đào sơn on 01/09/2022.
//

import RIBs
import RxSwift

protocol ChangePasswordRouting: ViewableRouting {
}

protocol ChangePasswordPresentable: Presentable {
    var listener: ChangePasswordPresentableListener? { get set }
    func bind(viewModel: ChangePasswordViewModel)
}

protocol ChangePasswordListener: AnyObject {
    func changePasswordWantToDismiss()
}

final class ChangePasswordInteractor: PresentableInteractor<ChangePasswordPresentable>, ChangePasswordInteractable {

    weak var router: ChangePasswordRouting?
    weak var listener: ChangePasswordListener?
    var changePasswordViewModel: ChangePasswordViewModel

    override init(presenter: ChangePasswordPresentable) {
        self.changePasswordViewModel = ChangePasswordViewModel()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: ChangePasswordPresentableListener
extension ChangePasswordInteractor: ChangePasswordPresentableListener {
    func didTapExitButton() {
        listener?.changePasswordWantToDismiss()
    }

    func didEndEditPassword(yourPassword: String, newPassword: String, confirmPassword: String) {
        self.changePasswordViewModel.updatePassword(yourPassword: yourPassword, newPassword: newPassword, confirmPassword: confirmPassword)
        self.changePasswordViewModel.updateInvalidLabelContent(isUpdateButtonClicked: false)

        presenter.bind(viewModel: self.changePasswordViewModel)
    }

    func didTapUpdateButton() {
        let savePasswordResult = self.changePasswordViewModel.savePassword()
        if savePasswordResult {
            listener?.changePasswordWantToDismiss()
            return
        } else {
            self.changePasswordViewModel.updateInvalidLabelContent(isUpdateButtonClicked: true)
        }

        presenter.bind(viewModel: self.changePasswordViewModel)
    }
}

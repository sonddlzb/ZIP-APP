//
//  InputPasswordInteractor.swift
//  Zip
//
//

import RIBs
import RxSwift

protocol InputPasswordRouting: ViewableRouting {
}

protocol InputPasswordPresentable: Presentable {
    var listener: InputPasswordPresentableListener? { get set }
    func bind(viewModel: InputPasswordViewModel)
    func clearPassword()
}

protocol InputPasswordListener: AnyObject {
    func inputPasswordWantToDismiss()
    func inputPasswordWantToSubmitPassword(password: String) -> Bool
    func inputPasswordDidSubmit(password: String)
}

final class InputPasswordInteractor: PresentableInteractor<InputPasswordPresentable>, InputPasswordInteractable {

    weak var router: InputPasswordRouting?
    weak var listener: InputPasswordListener?

    var viewModel: InputPasswordViewModel

    init(presenter: InputPasswordPresentable, purpose: InputPasswordPurpose) {
        self.viewModel = InputPasswordViewModel(password: "", purpose: purpose)
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.presenter.bind(viewModel: self.viewModel)
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - InputPasswordPresentableListener
extension InputPasswordInteractor: InputPasswordPresentableListener {
    func didSelectCancel() {
        listener?.inputPasswordWantToDismiss()
    }

    func didSelectOK() {
        if listener?.inputPasswordWantToSubmitPassword(password: self.viewModel.password) == false && self.viewModel.purpose == .extract {
            self.viewModel.password = ""
            self.viewModel.isIncorrectPassword = true
            self.presenter.bind(viewModel: self.viewModel)
            self.presenter.clearPassword()
        } else {
            listener?.inputPasswordDidSubmit(password: self.viewModel.password)
        }
    }

    func didEditPassword(password: String) {
        self.viewModel.password = password
        self.viewModel.isIncorrectPassword = false
        self.presenter.bind(viewModel: self.viewModel)
    }
}

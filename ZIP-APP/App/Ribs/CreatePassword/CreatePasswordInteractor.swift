//
//  CreatePasswordInteractor.swift
//  Zip
//
//  Created by đào sơn on 31/08/2022.
//

import RIBs
import RxSwift

protocol CreatePasswordRouting: ViewableRouting {
}

protocol CreatePasswordPresentable: Presentable {
    var listener: CreatePasswordPresentableListener? { get set }
    func bind(viewModel: CreatePasswordViewModel)
}

protocol CreatePasswordListener: AnyObject {
    func createPasswordWantToDismiss()
}

final class CreatePasswordInteractor: PresentableInteractor<CreatePasswordPresentable>, CreatePasswordInteractable {

    weak var router: CreatePasswordRouting?
    weak var listener: CreatePasswordListener?
    private var createPasswordViewModel: CreatePasswordViewModel

    override init(presenter: CreatePasswordPresentable) {
        self.createPasswordViewModel = CreatePasswordViewModel()
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

// MARK: CreatePasswordPresentableListener
extension CreatePasswordInteractor: CreatePasswordPresentableListener {
    func didTapCreateButton() {
        let savePasswordResult = self.createPasswordViewModel.savePassword()
        if savePasswordResult {
            listener?.createPasswordWantToDismiss()
            return
        }

        self.createPasswordViewModel
            .updateInvalidLabelContent(contentValue: "Please check your password")
        presenter.bind(viewModel: self.createPasswordViewModel)
    }

    func didEndEditPassword(enterPassword: String, confirmPassword: String) {
        self.createPasswordViewModel.updatePassword(enterPassword: enterPassword, confirmPassword: confirmPassword)
        self.createPasswordViewModel.updateInvalidLabelContent(contentValue: "Invalid password")
        presenter.bind(viewModel: self.createPasswordViewModel)
    }

    func didTapExitButton() {
        listener?.createPasswordWantToDismiss()
    }
}

//
//  InputToCompressInteractor.swift
//  Zip
//
//

import RIBs
import RxSwift

protocol InputToCompressRouting: ViewableRouting {
}

protocol InputToCompressPresentable: Presentable {
    var listener: InputToCompressPresentableListener? { get set }
    func bind(viewModel: InputToCompressViewModel)
}

protocol InputToCompressListener: AnyObject {
    func inputToCompressWantToDismiss()
    func inputToCompressDidSelectOK(name: String, isUsePassword: Bool, isReduceFileSize: Bool)
}

final class InputToCompressInteractor: PresentableInteractor<InputToCompressPresentable>, InputToCompressInteractable {

    weak var router: InputToCompressRouting?
    weak var listener: InputToCompressListener?

    var viewModel = InputToCompressViewModel(isUsePassword: false, isReduceFile: false, name: "Zip new")

    override init(presenter: InputToCompressPresentable) {
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

// MARK: - InputToCompressPresentableListener
extension InputToCompressInteractor: InputToCompressPresentableListener {
    func didSelectCancel() {
        listener?.inputToCompressWantToDismiss()
    }

    func didSelectOK(name: String) {
        listener?.inputToCompressDidSelectOK(name: name,
                                             isUsePassword: self.viewModel.isUsePassword,
                                             isReduceFileSize: self.viewModel.isReduceFile)
    }

    func didSetUsePassword(isOn: Bool) {
        self.viewModel.isUsePassword = isOn
    }

    func didSetReduceFileSize(isOn: Bool) {
        self.viewModel.isReduceFile = isOn
    }
}

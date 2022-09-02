//
//  AddFilePopupInteractor.swift
//  Zip
//
//

import RIBs
import RxSwift

protocol AddFilePopupRouting: ViewableRouting {
}

protocol AddFilePopupPresentable: Presentable {
    var listener: AddFilePopupPresentableListener? { get set }
}

protocol AddFilePopupListener: AnyObject {
    func addFilePopupWantToDismiss()
    func addFilePopupWantToAddFileFromPhoto()
    func addFilePopupWantToAddFileFromAudio()
}

final class AddFilePopupInteractor: PresentableInteractor<AddFilePopupPresentable>, AddFilePopupInteractable {

    weak var router: AddFilePopupRouting?
    weak var listener: AddFilePopupListener?

    override init(presenter: AddFilePopupPresentable) {
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

// MARK: - AddFilePopupPresentableListener
extension AddFilePopupInteractor: AddFilePopupPresentableListener {
    func didSelectAddFileFromPhoto() {
        listener?.addFilePopupWantToAddFileFromPhoto()
    }

    func didSelectAddFileFromAudio() {
        listener?.addFilePopupWantToAddFileFromAudio()
    }

    func didSelectClose() {
        listener?.addFilePopupWantToDismiss()
    }
}

//
//  CreateFolderInteractor.swift
//  Zip
//
//

import RIBs
import RxSwift

protocol CreateFolderRouting: ViewableRouting {
}

protocol CreateFolderPresentable: Presentable {
    var listener: CreateFolderPresentableListener? { get set }
    func bind(viewModel: CreateFolderViewModel)
}

protocol CreateFolderListener: AnyObject {
    func createFolderWantToDismiss()
    func createFolderDidCreated()
}

final class CreateFolderInteractor: PresentableInteractor<CreateFolderPresentable>, CreateFolderInteractable {

    weak var router: CreateFolderRouting?
    weak var listener: CreateFolderListener?

    var viewModel: CreateFolderViewModel

    init(presenter: CreateFolderPresentable, inputURL: URL) {
        self.viewModel = CreateFolderViewModel(parentURL: inputURL)
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

// MARK: - CreateFolderPresentableListener
extension CreateFolderInteractor: CreateFolderPresentableListener {
    func didSelectCancel() {
        listener?.createFolderWantToDismiss()
    }

    func didSelectOK(name: String) {
        let newFolderUrl = FileManager.getValidURL(withName: name, folderURL: self.viewModel.parentURL, pathExt: "")
        try? FileManager.default.createDirectory(at: newFolderUrl, withIntermediateDirectories: true)
        listener?.createFolderDidCreated()
    }
}

//
//  RenameItemInteractor.swift
//  Zip
//
//

import RIBs
import RxSwift
import TLLogging

protocol RenameItemRouting: ViewableRouting {
}

protocol RenameItemPresentable: Presentable {
    var listener: RenameItemPresentableListener? { get set }
    func bind(viewModel: RenameItemViewModel)
}

protocol RenameItemListener: AnyObject {
    func renameItemWantToDismiss()
    func renameItemDidRename(from sourceURL: URL, to destinationURL: URL)
}

final class RenameItemInteractor: PresentableInteractor<RenameItemPresentable>, RenameItemInteractable {

    weak var router: RenameItemRouting?
    weak var listener: RenameItemListener?

    var viewModel: RenameItemViewModel
    init(presenter: RenameItemPresentable, inputURL: URL) {
        self.viewModel = RenameItemViewModel(url: inputURL)
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

// MARK: - RenameItemPresentableListener
extension RenameItemInteractor: RenameItemPresentableListener {
    func didSelectCancel() {
        listener?.renameItemWantToDismiss()
    }

    func didSelectOK(name: String) {
        let newUrl = FileManager.getValidURL(withName: name, folderURL: self.viewModel.parentURL(), pathExt: self.viewModel.pathExtension())

        do {
            try FileManager.default.moveItem(atPath: self.viewModel.url.path, toPath: newUrl.path)
        } catch {
            TLLogging.log("Rename item \(self.viewModel.url) to \(newUrl) error: \(error)")
        }

        listener?.renameItemDidRename(from: self.viewModel.url, to: newUrl)
    }

    func isExistedName(name: String) -> Bool {
        let contents = (try? FileManager.default.contentsOfDirectory(atPath: self.viewModel.parentURL().path)) ?? []
        let foundName = name + (self.viewModel.pathExtension().isEmpty ? "" : ".\(self.viewModel.pathExtension())")
        return contents.contains(foundName)
    }
}

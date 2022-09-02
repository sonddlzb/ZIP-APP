//
//  HomeInteractor.swift
//  Zip
//
//

import RIBs
import RxSwift
import MediaPlayer
import Photos

protocol HomeRouting: ViewableRouting {
    func routeToMyFile(animated: Bool)
    func routeToMyfileIfNeeded()
    func dismissMyFile()
    func resetMyFileScreen(highlightedItemURL: URL?)
    func openFolder(url: URL)
    func openFolderDismissOpenZip()

    func routeToSelectMedia()
    func dismissSelectMedia(animated: Bool)
    func routeToSetting()
    func dismissSetting()
    func routeToSelectCategoryAudio()
    func dismissSelectCategoryAudio(animated: Bool)
    func routeToCompress(inputURLs: [URL], outputFolderURL: URL)
    func routeToCompress(audios: [MPMediaItem], outputFolderURL: URL)
    func routeToCompress(assets: [PHAsset], outputFolderURL: URL)
    func dismissCompress()
    func routeToExtract(zipURL: URL, outputFolderURL: URL)
    func dismissExtract()
    func routeToAddFileFromGoogleDrive(folderURL: URL)
    func dismissAddFileFromGoogleDrive()
    func routeToAddFileFromDropbox(folderURL: URL)
    func dismissAddFileFromDropbox()
    func routeToAddFileFromOneDrive(folderURL: URL)
    func dismissAddFileFromOneDrive()

    func showDocumentPicker()
}

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }
}

protocol HomeListener: AnyObject {
}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable {

    weak var router: HomeRouting?
    weak var listener: HomeListener?

    var addFileFolderURL: URL = FileManager.myFileURL()

    override init(presenter: HomePresentable) {
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

// MARK: - HomePresentableListener
extension HomeInteractor: HomePresentableListener {
    func didSelectPhoto() {
        self.addFileFolderURL = FileManager.myFileURL()
        self.router?.routeToSelectMedia()
    }

    func didSelectAudio() {
        self.addFileFolderURL = FileManager.myFileURL()
        self.router?.routeToSelectCategoryAudio()
    }

    func didSelectSetting() {
        self.router?.routeToSetting()
    }

    func didSelectMyFile() {
        self.router?.routeToMyFile(animated: true)
    }

    func didSelectGoogleDrive() {
        self.router?.routeToAddFileFromGoogleDrive(folderURL: FileManager.myFileURL())
    }

    func didSelectDropbox() {
        self.router?.routeToAddFileFromDropbox(folderURL: FileManager.myFileURL())
    }

    func didSelectOnedrive() {
        self.router?.routeToAddFileFromOneDrive(folderURL: FileManager.myFileURL())
    }

    func didSelectDocumentBrowser(urls: [URL]) {
        self.router?.routeToCompress(inputURLs: urls, outputFolderURL: self.addFileFolderURL)
    }

    func willShowDocumentPickerToAddToMyFile() {
        self.addFileFolderURL = FileManager.myFileURL()
    }
}

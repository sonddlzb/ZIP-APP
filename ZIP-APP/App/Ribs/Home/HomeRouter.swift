//
//  HomeRouter.swift
//  Zip
//
//  Created by Linh Nguyen Duc on 20/06/2022.
//

import Photos
import MediaPlayer
import RIBs
import TLLogging

protocol HomeInteractable: Interactable {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}


protocol HomeViewControllable: ViewControllable{
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable> {

    override init(interactor: HomeInteractable,
         viewController: HomeViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - HomeRouting
extension HomeRouter: HomeRouting {
    func routeToMyFile(animated: Bool) {

    }

    func routeToMyfileIfNeeded() {

    }

    func dismissMyFile() {

    }

    func resetMyFileScreen(highlightedItemURL: URL?) {

    }

    func openFolder(url: URL) {

    }

    func openFolderDismissOpenZip() {

    }

    func openFolderHighlightItem(url: URL) {

    }

    func routeToSelectMedia() {

    }

    func dismissSelectMedia(animated: Bool) {

    }

    func routeToSetting() {

    }

    func dismissSetting() {

    }

    func routeToSelectCategoryAudio() {

    }

    func dismissSelectCategoryAudio(animated: Bool) {

    }

    func routeToCompress(inputURLs: [URL], outputFolderURL: URL) {

    }

    func routeToCompress(audios: [MPMediaItem], outputFolderURL: URL) {

    }

    func routeToCompress(assets: [PHAsset], outputFolderURL: URL) {

    }

    func dismissCompress() {

    }

    func routeToExtract(zipURL: URL, outputFolderURL: URL) {

    }

    func dismissExtract() {

    }

    func routeToAddFileFromGoogleDrive(folderURL: URL) {

    }

    func dismissAddFileFromGoogleDrive() {

    }

    func routeToAddFileFromDropbox(folderURL: URL) {

    }

    func dismissAddFileFromDropbox() {

    }

    func routeToAddFileFromOneDrive(folderURL: URL) {

    }

    func dismissAddFileFromOneDrive() {

    }

    func showDocumentPicker() {

    }

}



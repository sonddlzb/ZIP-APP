//
//  HomeRouter.swift
//  Zip
//
//

import Photos
import MediaPlayer
import RIBs
import TLLogging

protocol HomeInteractable: Interactable, OpenFolderListener, SelectMediaListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}


protocol HomeViewControllable: ViewControllable{
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable> {
    var openFolderBuilder: OpenFolderBuildable
    var openFolderRouter: OpenFolderRouting?

    var selectMediaRouter: SelectMediaRouting?
    var selectMediaBuilder: SelectMediaBuildable

    init(interactor: HomeInteractable,
         viewController: HomeViewControllable,
         openFolderBuilder: OpenFolderBuildable,
         selectMediaBuilder: SelectMediaBuildable) {
        self.openFolderBuilder = openFolderBuilder
        self.selectMediaBuilder = selectMediaBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - HomeRouting
extension HomeRouter: HomeRouting {
    func openFolderDismissOpenZip() {
        guard let router = selectMediaRouter else {
            return
        }

        self.detachChild(router)
        self.selectMediaRouter = nil
        self.viewControllable.popToBefore(viewControllable: router.viewControllable)
    }

    func routeToSelectMedia() {
        let selectMediaRouter = selectMediaBuilder.build(withListener: interactor)
        self.viewControllable.push(viewControllable: selectMediaRouter.viewControllable)
        attachChild(selectMediaRouter)
        self.selectMediaRouter = selectMediaRouter
    }

    func dismissSelectMedia(animated: Bool) {
        guard let router = selectMediaRouter else {
            return
        }

        let detachBlock = {
            self.detachChild(router)
            self.selectMediaRouter = nil
        }

        if animated {
            self.viewControllable.popToBefore(viewControllable: router.viewControllable)
        }

        detachBlock()
    }

    func routeToMyFile(animated: Bool) {
        let router = openFolderBuilder.build(withListener: self.interactor, url: FileManager.myFileURL())
        self.viewControllable.push(viewControllable: router.viewControllable, animated: animated)
        attachChild(router)
        self.openFolderRouter = router
    }

    func routeToMyfileIfNeeded() {
        if self.openFolderRouter == nil {
            self.routeToMyFile(animated: false)
        }
    }

    func dismissMyFile() {
        guard let router = openFolderRouter else {
            return
        }

        self.viewControllable.popToBefore(viewControllable: router.viewControllable)
        detachChild(router)
        self.openFolderRouter = nil
    }

    func resetMyFileScreen(highlightedItemURL: URL?) {
        self.openFolderRouter?.resetScreen(highlightedItemURL: highlightedItemURL)
    }

    func openFolder(url: URL) {
        self.openFolderRouter?.openFolder(url: url)
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



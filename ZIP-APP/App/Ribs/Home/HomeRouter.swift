//
//  HomeRouter.swift
//  Zip
//
//

import Photos
import MediaPlayer
import RIBs
import TLLogging

protocol HomeInteractable: Interactable, OpenFolderListener, SelectMediaListener, CompressListener, ExtractListener, SelectCategoryAudioListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}


protocol HomeViewControllable: ViewControllable, ExtractViewControllable, CompressViewControllable{
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable> {
    var openFolderBuilder: OpenFolderBuildable
    var openFolderRouter: OpenFolderRouting?

    var selectMediaRouter: SelectMediaRouting?
    var selectMediaBuilder: SelectMediaBuildable

    var compressBuilder: CompressBuildable
    var compressRouter: CompressRouting?

    var extractBuilder: ExtractBuildable
    var extractRouter: ExtractRouting?

    var settingRouter: SettingRouting?
    var settingBuilder: SettingBuildable

    var selectCategoryAudioBuilder: SelectCategoryAudioBuildable
    var selectCategoryAudioRouter: SelectCategoryAudioRouting?

    init(interactor: HomeInteractable,
         viewController: HomeViewControllable,
         openFolderBuilder: OpenFolderBuildable,
         selectMediaBuilder: SelectMediaBuildable,
         settingBuilder: SettingBuildable,
         compressBuilder: CompressBuildable,
         extractBuilder: ExtractBuildable,
         selectCategoryAudioBuilder: SelectCategoryAudioBuildable) {
        self.openFolderBuilder = openFolderBuilder
        self.selectMediaBuilder = selectMediaBuilder
        self.compressBuilder = compressBuilder
        self.extractBuilder = extractBuilder
        self.settingBuilder = settingBuilder
        self.selectCategoryAudioBuilder = selectCategoryAudioBuilder
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
        let router = selectCategoryAudioBuilder.build(withListener: self.interactor)
        self.viewController.push(viewControllable: router.viewControllable)
        attachChild(router)
        self.selectCategoryAudioRouter = router
    }

    func dismissSelectCategoryAudio(animated: Bool) {
        guard let router = self.selectCategoryAudioRouter else {
            return
        }

        let detachRouterBlock = {
            self.detachChild(router)
            self.selectCategoryAudioRouter = nil
        }

        if animated {
            self.viewController.popToBefore(viewControllable: router.viewControllable, completion: detachRouterBlock)
        } else {
            detachRouterBlock()
        }
    }

    func routeToCompress(inputURLs: [URL], outputFolderURL: URL) {
        guard compressRouter == nil else {
            DCHECK(false)
            return
        }

        let router = compressBuilder.build(withListener: self.interactor, inputURLs: inputURLs, outputFolderURL: outputFolderURL)
        attachChild(router)
        self.compressRouter = router
    }

    func routeToCompress(audios: [MPMediaItem], outputFolderURL: URL) {
        guard compressRouter == nil else {
            DCHECK(false)
            return
        }

        let router = compressBuilder.build(withListener: self.interactor, audios: audios, outputFolderURL: outputFolderURL)
        attachChild(router)
        self.compressRouter = router
    }

    func routeToCompress(assets: [PHAsset], outputFolderURL: URL) {
        DCHECK(compressRouter == nil)
        let router = compressBuilder.build(withListener: self.interactor, assets: assets, outputFolderURL: outputFolderURL)
        attachChild(router)
        self.compressRouter = router
    }

    func dismissCompress() {
        guard let router = compressRouter else {
            return
        }

        detachChild(router)
        self.compressRouter = nil
    }

    func routeToExtract(zipURL: URL, outputFolderURL: URL) {
        let router = extractBuilder.build(withListener: self.interactor, zipURL: zipURL, outputFolderURL: outputFolderURL)
        attachChild(router)
        self.extractRouter = router
    }

    func dismissExtract() {
        guard let router = extractRouter else {
            return
        }

        detachChild(router)
        self.extractRouter = nil
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



//
//  CompressInteractor.swift
//  Zip
//
//

import Photos

import MediaPlayer
import RIBs
import RxSwift
import TLLogging

private struct Const {
    static let megaByte: Int = 1000000
    static let compressedFolderPath = NSTemporaryDirectory() + "/compressedFolder"
}

protocol CompressRouting: Routing {

    func routeToInputToCompress()
    func dismissInputToCompress()
    func routeToLoading()
    func dismissLoading()
    func routeToInputPassword()
    func dismissInputPassword()
}

protocol CompressListener: AnyObject {
    func compressWantToDismiss()
    func compressDidCompressDone(zipURL: URL)
}

final class CompressInteractor: Interactor, CompressInteractable {

    weak var router: CompressRouting?
    weak var listener: CompressListener?

    var stagedZipURL: URL?
    var isReduceSize: Bool = false

    var inputValue: CompressInputValue
    var outputFolderURL: URL

    init(inputValue: CompressInputValue, outputFolderURL: URL) {
        self.inputValue = inputValue
        self.outputFolderURL = outputFolderURL
        super.init()
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.router?.routeToInputToCompress()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    // MARK: - Helper
    func handleCompress(password: String? = nil) {
        guard let zipURL = stagedZipURL else {
            return
        }

        self.router?.routeToLoading()
        DispatchQueue.global().async {
            switch self.inputValue {
            case .urls(let urls):
                self.handleCompressingURLs(urls,
                                           zipURL: zipURL,
                                           password: password,
                                           isReduceFileSize: self.isReduceSize)
            case .audios(let audios):
                self.handleCompressingAudio(audios,
                                            zipURL: zipURL,
                                            password: password,
                                            isReduceFileSize: self.isReduceSize)
            case .assets(let assets):
                self.handleCompressingAssets(assets,
                                             zipURL: zipURL,
                                             password: password,
                                             isReduceFileSize: self.isReduceSize)
            }
        }
    }

    private func handleCompressingURLs(_ inputURLs: [URL], zipURL: URL, password: String? = nil, isReduceFileSize: Bool = false) {
        try? FileManager.default.removeItem(atPath: Const.compressedFolderPath)
        try? FileManager.default.createDirectory(atPath: Const.compressedFolderPath, withIntermediateDirectories: true)

        inputURLs.forEach { url in
            let filename = url.lastPathComponent
            try? FileManager.default.copyItem(atPath: url.path, toPath: "\(Const.compressedFolderPath)/\(filename)")
        }

        self.compressCompressedFolder(zipURL: zipURL, password: password, isReduceFileSize: isReduceFileSize)
    }

    private func handleCompressingAudio(_ audios: [MPMediaItem], zipURL: URL, password: String? = nil, isReduceFileSize: Bool = false) {
        let exportAudioSession = ExportAudioSession(audios: audios)

        try? FileManager.default.removeItem(atPath: Const.compressedFolderPath)
        try? FileManager.default.createDirectory(atPath: Const.compressedFolderPath, withIntermediateDirectories: true)

        exportAudioSession.export(outputFolderURL: URL(fileURLWithPath: Const.compressedFolderPath)) { [weak self] error in
            if let error = error {
                TLLogging.log("Export audio error: \(error)")
                DispatchQueue.main.async {
                    self?.showError("Compressing error")
                    self?.listener?.compressWantToDismiss()
                }

                return
            } else {
                TLLogging.log("Export audio done")
            }

            self?.compressCompressedFolder(zipURL: zipURL, password: password, isReduceFileSize: isReduceFileSize)
        }
    }

    private func handleCompressingAssets(_ assets: [PHAsset], zipURL: URL, password: String? = nil, isReduceFileSize: Bool = false) {
        try? FileManager.default.removeItem(atPath: Const.compressedFolderPath)
        try? FileManager.default.createDirectory(atPath: Const.compressedFolderPath, withIntermediateDirectories: true)

        let exportAssetSession = ExportAssetSession(assets: assets)
        let compresedFolderURL = URL(fileURLWithPath: Const.compressedFolderPath)
        exportAssetSession.export(outputFolderURL: compresedFolderURL) { [weak self] error in
            guard let self = self else {
                return
            }

            if let error = error {
                TLLogging.log("Export assets error: \(error)")
                DispatchQueue.main.async {
                    self.showError("Compressing error")
                    self.listener?.compressWantToDismiss()
                }

                return
            }

            self.compressCompressedFolder(zipURL: zipURL, password: password, isReduceFileSize: isReduceFileSize)
        }
    }

    private func compressCompressedFolder(zipURL: URL, password: String?, isReduceFileSize: Bool) {
        let compressionLevel = Int32(isReduceFileSize ? 3 : 1) // this param will get from user default
        SSZipArchive.createZipFile(atPath: zipURL.path,
                                   withContentsOfDirectory: Const.compressedFolderPath,
                                   keepParentDirectory: false,
                                   compressionLevel: compressionLevel,
                                   password: password,
                                   aes: password != nil,
                                   progressHandler: { [weak self] currentIndex, total in
            TLLogging.log("Compressing: \(currentIndex)/\(total)")
            if currentIndex == total {
                self?.handleCompressingDone()
            }
        })
    }

    private func handleCompressingDone() {
        try? FileManager.default.removeItem(atPath: Const.compressedFolderPath)
        // delay 1s to improve UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            TLLogging.log("Compress done")
            self.router?.dismissLoading()
            if let stagedZipURL = self.stagedZipURL {
                self.listener?.compressDidCompressDone(zipURL: stagedZipURL)
            }
        }
    }

    private func showError(_ message: String) {
        NotificationBannerView.show(message, icon: .warning)
    }
}

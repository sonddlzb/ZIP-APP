//
//  ExtractInteractor.swift
//  Zip
//
//

import RIBs
import RxSwift
import TLLogging

private struct Const {
    static let tempOutputFolderPath = NSTemporaryDirectory() + "/extractedFolder"
}

protocol ExtractRouting: Routing {
    var viewController: ExtractViewControllable { get }
    func routeToInputPassword()
    func dismissInputPassword()
    func routeToExtractLoading()
    func dismissExtractLoading()
}

protocol ExtractListener: AnyObject {
    func extractWantToDismiss()
    func extractDidExtractingDone(zipFolderURL: URL)
}

final class ExtractInteractor: Interactor, ExtractInteractable {

    weak var router: ExtractRouting?
    weak var listener: ExtractListener?

    var zipURL: URL
    var outputFolderURL: URL
    var password: String?

    init(zipURL: URL, outputFolderURL: URL) {
        self.zipURL = zipURL
        self.outputFolderURL = outputFolderURL
        super.init()
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        if SSZipArchive.isFilePasswordProtected(atPath: zipURL.path) {
            self.router?.routeToInputPassword()
        } else {
            self.router?.viewController.showAskBeforeExtractingDialog(action: {
                self.handleExtracting()
            }, cancelAction: {
                self.listener?.extractWantToDismiss()
            })
        }
    }

    override func willResignActive() {
        super.willResignActive()
    }

    // MARK: - Helper
    func isPasswordZipCorrected(password: String) -> Bool {
        SSZipArchive.isPasswordValidForArchive(atPath: zipURL.path, password: password, error: nil)
    }

    func folderTemporaryOutputPath() -> String {
        return Const.tempOutputFolderPath + "/" + self.zipURL.deletingPathExtension().lastPathComponent
    }

    func handleExtracting() {
        self.router?.routeToExtractLoading()
        let folderOutputPath = self.folderTemporaryOutputPath()
        DispatchQueue.global().async {
            try? FileManager.default.removeItem(atPath: folderOutputPath)
            try? FileManager.default.createDirectory(atPath: folderOutputPath, withIntermediateDirectories: true)

            SSZipArchive.unzipFile(atPath: self.zipURL.path,
                                   toDestination: folderOutputPath,
                                   overwrite: false,
                                   password: self.password) { name, _, currentIndex, total in
                TLLogging.log("Extracting \(name) \(currentIndex)/\(total)")
            } completionHandler: { [weak self] _, _, error in
                DispatchQueue.main.async {
                    self?.handleExtractingDone(error: error)
                }
            }
        }
    }

    private func handleExtractingDone(error: Error?) {
        // delay 1s to improve UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else {
                return
            }

            let folderTemporaryOutputURL = URL(fileURLWithPath: self.folderTemporaryOutputPath())
            let name = self.zipURL.deletingPathExtension().lastPathComponent
            let destinationURL = FileManager.getValidURL(withName: name,
                                                         folderURL: self.outputFolderURL,
                                                         pathExt: "")
            try? FileManager.default.moveItem(at: folderTemporaryOutputURL, to: destinationURL)

            self.router?.dismissExtractLoading()
            if let error = error {
                TLLogging.log("Extract error: \(error)")
                self.showError("Extracting error")
            } else {
                self.listener?.extractDidExtractingDone(zipFolderURL: destinationURL)
            }
        }
    }

    private func showError(_ message: String) {
        NotificationBannerView.show(message, icon: .warning)
    }
}

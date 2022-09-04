//
//  ExportAssetOperation.swift
//  Zip
//
//

import Foundation
import Photos

import TLLogging

class ExportAssetOperation: Operation {
    var asset: PHAsset
    var outputFolderURL: URL
    private(set) var error: Error?
    private var exportSession: AVAssetExportSession?

    init(asset: PHAsset, outputFolderURL: URL) {
        self.asset = asset
        self.outputFolderURL = outputFolderURL
    }

    private var isExecutingPrivate: Bool = false
    private var isFinishedPrivate: Bool = false

    // MARK: - Override properties
    override var isAsynchronous: Bool {
        return true
    }

    override private(set) var isExecuting: Bool {
        get {
            return self.isExecutingPrivate
        }

        set {
            willChangeValue(forKey: "isExecuting")
            self.isExecutingPrivate = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }

    override private(set) var isFinished: Bool {
        get {
            return isFinishedPrivate
        }

        set {
            willChangeValue(forKey: "isFinished")
            self.isFinishedPrivate = newValue
            didChangeValue(forKey: "isFinished")
        }
    }

    // MARK: - Override method
    override func start() {
        isFinished = false
        isExecuting = true
        self.error = nil
        main()
    }

    override func main() {
        if asset.mediaType == .image {
            let settingManager = SettingManager()
            let name = asset.localIdentifier.replacingOccurrences(of: "/", with: "")
            let image = asset.getImage()
            let outputURL = self.outputFolderURL.appendingPathComponent(name).appendingPathExtension("jpg")
            do {
                try image?.jpegData(compressionQuality: settingManager.currentDefaultPhotoSize().compressionQuality())?.write(to: outputURL)
            } catch {
                self.error = error
            }

            self.finish()
            return
        }

        guard let avAsset = asset.getAVAsset() as? AVURLAsset,
              let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPreset1280x720) else {
            self.error = NSError(domain: "Getting AVAsset or create export session error", code: 0)
            self.finish()
            return
        }

        self.exportSession = exportSession
        exportSession.outputFileType = .mp4
        let outputURL = outputFolderURL.appendingPathComponent(avAsset.url.deletingPathExtension().lastPathComponent).appendingPathExtension("mp4")
        exportSession.outputURL = outputURL
        TLLogging.log("Start export asset \(self.asset.localIdentifier)")
        exportSession.exportAsynchronously {
            TLLogging.log("Export asset \(self.asset.localIdentifier) done")
            if self.exportSession?.error != nil {
                self.error = self.exportSession?.error
            }

            self.finish()
        }
    }

    override func cancel() {
        super.cancel()
        if self.exportSession?.status == .exporting {
            self.exportSession?.cancelExport()
        }
    }

    func finish() {
        self.exportSession = nil
        self.isExecuting = false
        self.isFinished = true
    }
}

//
//  ExportAudioOperation.swift
//  Zip
//
//

import AVFoundation
import Foundation
import MediaPlayer

class ExportAudioOperation: Operation {
    var outputFolderURL: URL
    var audio: MPMediaItem
    var error: Error?
    private var exportSession: AVAssetExportSession!

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

    // MARK: - Init
    init(audio: MPMediaItem, outputFolderURL: URL) {
        self.audio = audio
        self.outputFolderURL = outputFolderURL
    }

    // MARK: - Override method
    override func start() {
        if self.isCancelled {
            return
        }

        isFinished = false
        isExecuting = true
        main()
    }

    override func main() {
        if self.isCancelled {
            return
        }

        guard let assetURL = audio.assetURL else {
            self.error = NSError(domain: "Asset url is nil", code: 0)
            self.completionBlock?()
            return
        }

        let asset = AVAsset(url: assetURL)
        exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)!
        exportSession.outputFileType = .m4a
        exportSession.outputURL = self.outputFolderURL.appendingPathComponent("\(audio.title ?? "unknown").m4a")
        exportSession.exportAsynchronously {
            self.error = self.exportSession.error
            self.finish()
        }
    }

    override func cancel() {
        super.cancel()
        if exportSession != nil, exportSession.status == .exporting {
            exportSession.cancelExport()
        }
    }

    func finish() {
        self.isFinished = true
        self.isExecuting = false
    }
}

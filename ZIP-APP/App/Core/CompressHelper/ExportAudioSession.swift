//
//  ExportAudioSession.swift
//  Zip
//
//

import Foundation
import MediaPlayer

class ExportAudioSession {
    private(set) var audios: [MPMediaItem]
    private lazy var exportAudioOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()

    init(audios: [MPMediaItem]) {
        self.audios = audios
    }

    func export(outputFolderURL: URL, completion: ((Error?) -> Void)? = nil) {
        DispatchQueue.global().async {
            try? FileManager.default.removeItem(at: outputFolderURL)
            try? FileManager.default.createDirectory(at: outputFolderURL, withIntermediateDirectories: true)

            var exportingError: Error?
            let listOperation: [Operation] = self.audios.map { audio in
                let exportAudioOperation = ExportAudioOperation(audio: audio, outputFolderURL: outputFolderURL)
                exportAudioOperation.completionBlock = { [weak self] in
                    if let error = exportAudioOperation.error {
                        exportingError = error
                        self?.exportAudioOperationQueue.cancelAllOperations()
                    }
                }

                return exportAudioOperation
            }

            self.exportAudioOperationQueue.addOperations(listOperation, waitUntilFinished: true)
            completion?(exportingError)
        }
    }
}

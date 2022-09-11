//
//  GoogleDriveService.swift
//  Zip
//
//

import Foundation

import GoogleAPIClientForREST
import GoogleSignIn
import RxSwift
import TLLogging

class GoogleDriveServiceInfo {
    static var current = GoogleDriveServiceInfo()

    init() {
        self.names = [
            "root": "Google drive"
        ]

        self.isItemIdDownloading = [:]
    }

    private var names: [String: String]
    private var isItemIdDownloading: [String: Bool]

    func markDownloading(itemId: String) {
        isItemIdDownloading[itemId] = true
    }

    func unmarkDownloading(itemId: String) {
        isItemIdDownloading.removeValue(forKey: itemId)
    }

    func isDownloading(itemId: String) -> Bool {
        return isItemIdDownloading[itemId] ?? false
    }

    func name(id: String) -> String? {
        return names[id]
    }

    func saveName(item: GoogleDriveItem) {
        self.names[item.identifier()] = item.name()
    }
}

class GoogleDriveService {
    static var shared = GoogleDriveService()
    var downloadFolderURL: URL = FileManager.myFileURL()

    private var startDownloadingSubject = PublishSubject<Event<CloudItem>>()
    private var endDownloadingSubject = PublishSubject<Event<CloudItem>>()
    private var service: GTLRDriveService
    private var info: GoogleDriveServiceInfo {
        return GoogleDriveServiceInfo.current
    }

    init() {
        self.service = GTLRDriveService()
    }
}

// MARK: - CloudService
extension GoogleDriveService: CloudService {
    var startDownloadingObserver: Observable<Event<CloudItem>> {
        return self.startDownloadingSubject.asObserver()
    }

    var endDownloadingObserver: Observable<Event<CloudItem>> {
        return self.endDownloadingSubject.asObserver()
    }

    func isDownloading(id: String) -> Bool {
        self.info.isDownloading(itemId: id)
    }

    func folderName(id: String) -> String? {
        self.info.name(id: id)
    }

    func fetch(item: CloudItem, completion: @escaping ([CloudItem]?, Error?) -> Void) {
        self.service.authorizer = GIDSignIn.sharedInstance.currentUser?.authentication.fetcherAuthorizer()
        let query = GTLRDriveQuery_FilesList.query()
        query.fields = "*"
        query.q = "trashed = false and '\(item.identifier())' In parents"
        service.executeQuery(query) { _, files, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let files = (files as? GTLRDrive_FileList)?.files else {
                completion([], nil)
                return
            }

            let listItems = files.map({ GoogleDriveItem(item: $0) })
            listItems.forEach({ self.info.saveName(item: $0) })
            completion(listItems, nil)
        }
    }

    func download(item: CloudItem) {
        let fileId = item.identifier()
        guard !self.isDownloading(id: fileId),
              let item = item as? GoogleDriveItem else {
            return
        }

        guard let fileExtension = item.fileExtension() else {
            TLLogging.log("File is not enough infomations to download")
            return
        }

        self.info.markDownloading(itemId: fileId)
        self.startDownloadingSubject.onNext(.next(item))

        self.service.authorizer = GIDSignIn.sharedInstance.currentUser?.authentication.fetcherAuthorizer()

        let filename: String
        if item.name().hasSuffix(fileExtension) {
            filename = "\(item.name().dropLast(fileExtension.count + 1))"
        } else {
            filename = item.name()
        }

        let outputURL = FileManager.getValidURL(withName: filename, folderURL: self.downloadFolderURL, pathExt: fileExtension)
        let query: GTLRDriveQuery
        if let mimeType = item.mimeType(), MimeType(mimeType).needExport() {
            query = GTLRDriveQuery_FilesExport.queryForMedia(withFileId: fileId,
                                                             mimeType: MimeType(mimeType).exportedMimeType())
        } else {
            query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileId)
        }

        let downloadRequest = self.service.request(for: query) as URLRequest
        let fetcher = self.service.fetcherService.fetcher(with: downloadRequest)
        fetcher.comment = item.name()
        fetcher.destinationFileURL = outputURL
        fetcher.beginFetch { _, error in
            self.info.unmarkDownloading(itemId: fileId)
            if let error = error {
                self.endDownloadingSubject.onNext(.error(error))
            } else {
                self.endDownloadingSubject.onNext(.next(item))
            }
        }
    }
}

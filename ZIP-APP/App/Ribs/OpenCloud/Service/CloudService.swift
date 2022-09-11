//
//  DriveService.swift
//  Zip
//
//

import Foundation
import RxSwift

protocol CloudService {
    var downloadFolderURL: URL { get set }
    var startDownloadingObserver: Observable<Event<CloudItem>> { get }
    var endDownloadingObserver: Observable<Event<CloudItem>> { get }

    func isDownloading(id: String) -> Bool
    func folderName(id: String) -> String?
    func fetch(item: CloudItem, completion: @escaping ([CloudItem]?, Error?) -> Void)
    func download(item: CloudItem)
}

//
//  CompressInteractor+InputToCompress.swift
//  Zip
//
//

import Foundation

extension CompressInteractor: InputToCompressListener {
    func inputToCompressWantToDismiss() {
        self.router?.dismissInputToCompress()
        listener?.compressWantToDismiss()
    }

    func inputToCompressDidSelectOK(name: String, isUsePassword: Bool, isReduceFileSize: Bool) {
        self.router?.dismissInputToCompress()
        self.stagedZipURL = FileManager.getValidURL(withName: name, folderURL: self.outputFolderURL, pathExt: "zip")
        self.isReduceSize = isReduceFileSize

        if !isUsePassword {
            self.handleCompress(password: nil)
            return
        }

        let settingManager = SettingManager()
        if !settingManager.hasPassword() {
            self.router?.routeToInputPassword()
            return
        }

        self.handleCompress(password: settingManager.currentPassword())
    }
}

//
//  CreateFolderViewModel.swift
//  Zip
//
//

import Foundation

struct CreateFolderViewModel {
    var parentURL: URL

    func title() -> String {
        return "Your new folder name"
    }

    func placeholder() -> String {
        return "Folder name cannot be empty"
    }
}

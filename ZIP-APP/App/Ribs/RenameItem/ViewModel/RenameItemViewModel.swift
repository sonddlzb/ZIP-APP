//
//  RenameItemViewModel.swift
//  Zip
//
//

import Foundation

struct RenameItemViewModel {
    var url: URL

    func name() -> String {
        return url.deletingPathExtension().lastPathComponent
    }

    func pathExtension() -> String {
        return url.pathExtension
    }

    func title() -> String {
        return "Rename item"
    }

    func placeholderForTextfield() -> String {
        return "Item name cannot be empty"
    }

    func parentURL() -> URL {
        return self.url.deletingLastPathComponent()
    }
}

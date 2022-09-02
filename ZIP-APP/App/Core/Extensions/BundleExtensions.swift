//
//  BundleExtensions.swift
//  Core
//
//

import Foundation

public extension Bundle {
    static func resourceBundle(name: String) -> Bundle {
        for bundle in Bundle.allBundles {
            if let path = bundle.path(forResource: name, ofType: "bundle") {
                return Bundle(path: path)!
            }
        }

        fatalError()
    }
}

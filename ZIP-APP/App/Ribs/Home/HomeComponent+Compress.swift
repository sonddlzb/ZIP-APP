//
//  HomeComponent+Compress.swift
//  Zip
//
//

import Foundation

extension HomeComponent: CompressDependency {
    var compressViewController: CompressViewControllable {
        return self.viewController
    }
}

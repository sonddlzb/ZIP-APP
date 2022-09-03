//
//  HomeComponent+Extract.swift
//  Zip
//
//

import Foundation

extension HomeComponent: ExtractDependency {
    var extractViewController: ExtractViewControllable {
        return self.viewController
    }
}

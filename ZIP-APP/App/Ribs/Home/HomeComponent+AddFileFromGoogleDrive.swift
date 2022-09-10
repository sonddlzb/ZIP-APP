//
//  HomeComponent+AddFileFromGoogleDrive.swift
//  Zip
//
//

import Foundation

extension HomeComponent: AddFileFromGoogleDriveDependency {
    var addFileFromGoogleDriveViewController: AddFileFromGoogleDriveViewControllable {
        return self.viewController
    }
}

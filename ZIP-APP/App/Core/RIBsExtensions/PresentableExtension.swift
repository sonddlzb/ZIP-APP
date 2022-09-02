//
//  PresentableExtension.swift
//  RIBsExtensions
//
//

import Foundation
import SVProgressHUD
import RIBs

public extension Presentable {
    func showError(message: String) {
        NotificationBannerView.show(message, icon: .warning)
    }
}

// MARK: - Presentable + Loading
public extension Presentable {
    func showLoading() {
        SVProgressHUD.show()
    }

    func dismissLoading() {
        SVProgressHUD.dismiss()
    }

    func showLoading(progress: Float) {
        SVProgressHUD.showProgress(progress, status: "\(Int(progress*100))%")
    }
}

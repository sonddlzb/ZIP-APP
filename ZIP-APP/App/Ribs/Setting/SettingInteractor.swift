//
//  SettingInteractor.swift
//  Zip
//
//  Created by đào sơn on 30/08/2022.
//

import RIBs
import RxSwift
import TLLogging

protocol SettingRouting: ViewableRouting {
    func routeToCreatePassword()
    func dismissCreatePassword()
    func routeToChangePassword()
    func dismissChangePassword()
}

protocol SettingPresentable: Presentable {
    var listener: SettingPresentableListener? { get set }
    func bind(viewModel: SettingViewModel)
}

protocol SettingListener: AnyObject {
    func settingWantToDismiss()
}

final class SettingInteractor: PresentableInteractor<SettingPresentable>, SettingInteractable {

    weak var router: SettingRouting?
    weak var listener: SettingListener?
    var settingViewModel: SettingViewModel

    override init(presenter: SettingPresentable) {
        self.settingViewModel = SettingViewModel()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: SetttingPresentableListener
extension SettingInteractor: SettingPresentableListener {
    func didTapOriginalRadioButton() {
        self.settingViewModel.changeDefaultPhotoSize(photoSize: .original)
        presenter.bind(viewModel: self.settingViewModel)
    }

    func didTapMediumRadioButton() {
        self.settingViewModel.changeDefaultPhotoSize(photoSize: .medium)
        presenter.bind(viewModel: self.settingViewModel)
    }

    func didTapSmallRadioButton() {
        self.settingViewModel.changeDefaultPhotoSize(photoSize: .small)
        presenter.bind(viewModel: self.settingViewModel)
    }

    func didTapBackButton() {
        listener?.settingWantToDismiss()
    }

    func createPassword() {
        router?.routeToCreatePassword()
    }

    func deletePassword() {
        self.settingViewModel.deleteCurrentPassword()
    }

    func didTapChangePasswordButton() {
        router?.routeToChangePassword()
    }

    func getAndBindDataStorage() {
        do {
            if let storageSize = try FileManager.myFileURL().totalSizeOnDiskForAllFiles() {
                self.settingViewModel.storageSize = storageSize
            }

            if let photoSize = try FileManager.myFileURL().totalSizeOnDiskForPhotos() {
                self.settingViewModel.photoSize = photoSize
            }

            if let audioSize = try FileManager.myFileURL().totalSizeOnDiskForAudios() {
                self.settingViewModel.audioSize = audioSize
            }
        } catch {
            TLLogging.log("\(error)")
        }

        presenter.bind(viewModel: self.settingViewModel)
    }
}

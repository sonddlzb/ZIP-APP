//
//  SelectCategoryAudioInteractor.swift
//  Zip
//
//

import UIKit
import MediaPlayer
import RIBs
import RxCocoa

protocol SelectCategoryAudioRouting: ViewableRouting {
    func routeToSelectAudio(category: MPMediaItemCollection)
    func dismissSelectAudio()
    func removeViewControllerFromNavigation()
}

protocol SelectCategoryAudioPresentable: Presentable {
    var listener: SelectCategoryAudioPresentableListener? { get set }
    func bind(viewModel: SelectCategoryViewModel)
    func displayNoPermission()
}

protocol SelectCategoryAudioListener: AnyObject {
    func selectCategoryAudioWantToDismiss()
    func selectCategoryAudioWantToCompress(audios: [MPMediaItem])
}

final class SelectCategoryAudioInteractor: PresentableInteractor<SelectCategoryAudioPresentable>, SelectCategoryAudioInteractable {

    weak var router: SelectCategoryAudioRouting?
    weak var listener: SelectCategoryAudioListener?

    override init(presenter: SelectCategoryAudioPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchCategories()

        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification).subscribe { _ in
            // delay 0.5s for MPMediaQuery update new infomations
            self.presenter.showLoading()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.presenter.dismissLoading()
                self?.fetchCategories()
            }
        }.disposeOnDeactivate(interactor: self)
    }

    override func willResignActive() {
        super.willResignActive()
        self.router?.removeViewControllerFromNavigation()
    }

    // MARK: - Helper
    private func fetchCategories() {
        MPMediaLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                self.handleLoadingCategories(authorizationStatus: status)
            }
        }
    }

    private func handleLoadingCategories(authorizationStatus: MPMediaLibraryAuthorizationStatus) {
        guard authorizationStatus == .authorized else {
            self.presenter.displayNoPermission()
            return
        }

        guard let categories = MPMediaQuery.artists().collections else {
            self.presenter.bind(viewModel: SelectCategoryViewModel(categories: []))
            return
        }

        self.presenter.bind(viewModel: SelectCategoryViewModel(categories: categories))
    }
}

// MARK: - SelectCategoryAudioPresentableListener
extension SelectCategoryAudioInteractor: SelectCategoryAudioPresentableListener {
    func didSelectBack() {
        listener?.selectCategoryAudioWantToDismiss()
    }

    func didSelect(itemViewModel: SelectCategoryItemViewModel) {
        self.router?.routeToSelectAudio(category: itemViewModel.category)
    }

    func didSelectGrantAccess() {
        let url = URL(string: UIApplication.openSettingsURLString)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

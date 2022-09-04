//
//  SelectAudioInteractor.swift
//  Zip
//
//

import MediaPlayer
import RIBs
import RxCocoa
import RxSwift

protocol SelectAudioRouting: ViewableRouting {
    func removeViewControllerFromNavigation()
}

protocol SelectAudioPresentable: Presentable {
    var listener: SelectAudioPresentableListener? { get set }
    func bind(viewModel: SelectAudioViewModel, needReloadPlayer: Bool)
}

protocol SelectAudioListener: AnyObject {
    func selectAudioWantToDismiss()
    func selectAudioWantToCompress(audios: [MPMediaItem])
}

final class SelectAudioInteractor: PresentableInteractor<SelectAudioPresentable>, SelectAudioInteractable {

    weak var router: SelectAudioRouting?
    weak var listener: SelectAudioListener?

    var viewModel: SelectAudioViewModel

    init(presenter: SelectAudioPresentable, category: MPMediaItemCollection) {
        self.viewModel = SelectAudioViewModel(collection: category)
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.presenter.bind(viewModel: self.viewModel, needReloadPlayer: false)
        self.registerNotificationCenter()
    }

    override func willResignActive() {
        super.willResignActive()
        self.router?.removeViewControllerFromNavigation()
    }

    private func registerNotificationCenter() {
        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification).subscribe { _ in
            self.presenter.showLoading()
            // delay 1s for MPMediaQuery update new infomations
            DispatchQueue.main.asyncAfter(deadline: .now()+1) { [weak self] in
                guard let self = self else {
                    return
                }

                self.presenter.dismissLoading()
                self.viewModel.refresh()
                if self.viewModel.collection == nil {
                    self.listener?.selectAudioWantToDismiss()
                    return
                }

                self.presenter.bind(viewModel: self.viewModel, needReloadPlayer: self.viewModel.playingItem == nil)
            }
        }.disposeOnDeactivate(interactor: self)
    }
}

// MARK: - SelectAudioPresentableListener
extension SelectAudioInteractor: SelectAudioPresentableListener {
    func didSelectBack() {
        listener?.selectAudioWantToDismiss()
    }

    func didSelectPlayPlayer(item: SelectAudioItemViewModel) {
        self.viewModel.playingItem = item.audioItem
        self.presenter.bind(viewModel: self.viewModel, needReloadPlayer: true)
    }

    func didSelectPausePlayer() {
        self.viewModel.playingItem = nil
        self.presenter.bind(viewModel: self.viewModel, needReloadPlayer: true)
    }

    func didSelectItem(_ item: SelectAudioItemViewModel) {
        self.viewModel.reverseSelectedState(item: item.audioItem)
        self.presenter.bind(viewModel: self.viewModel, needReloadPlayer: false)
    }

    func didSelectAll() {
        self.viewModel.selectAll()
        self.presenter.bind(viewModel: self.viewModel, needReloadPlayer: false)
    }

    func didUnselectAll() {
        self.viewModel.unselectAll()
        self.presenter.bind(viewModel: self.viewModel, needReloadPlayer: false)
    }

    func didSelectOptionAction(_ action: OptionActionType) {
        if action == .compress {
            let selectedItems = self.viewModel.selectedItems()
            listener?.selectAudioWantToCompress(audios: selectedItems)
        }
    }

    func didCancelSelectingMode() {
        self.viewModel.isSelectingModeEnabled = false
        self.viewModel.unselectAll()
        self.presenter.bind(viewModel: self.viewModel, needReloadPlayer: false)
    }
}

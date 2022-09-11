//
//  OpenCloudInteractor.swift
//  Zip
//
//

import RIBs
import RxCocoa
import RxSwift
import TLLogging

protocol OpenCloudRouting: ViewableRouting {
    func routeToOpenCloud(cloudItem: CloudItem, parentId: String?, cloudService: CloudService)
    func dismissOpenCloud()
}

protocol OpenCloudPresentable: Presentable {
    var listener: OpenCloudPresentableListener? { get set }
    func bind(viewModel: OpenCloudViewModel)
}

protocol OpenCloudListener: AnyObject {
    func openCloudWantToDismiss()
    func openCloudWantToLogout()
    func openCloudDidDownloadSuccessfully()
}

final class OpenCloudInteractor: PresentableInteractor<OpenCloudPresentable>, OpenCloudInteractable {

    weak var router: OpenCloudRouting?
    weak var listener: OpenCloudListener?

    var cloudService: CloudService
    var viewModel: OpenCloudViewModel
    var cloudItem: CloudItem

    init(presenter: OpenCloudPresentable, cloudItem: CloudItem, parentId: String?, cloudService: CloudService) {
        self.cloudService = cloudService
        self.cloudItem = cloudItem
        self.viewModel = OpenCloudViewModel(id: cloudItem.identifier(), parentId: parentId, service: cloudService)
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.subscribeDownloadingEvents()
        self.fetchData()

        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification).subscribe { [unowned self] _ in
            self.fetchData()
        }.disposeOnDeactivate(interactor: self)
    }

    override func willResignActive() {
        super.willResignActive()
    }

    // MARK: - Helper
    private func subscribeDownloadingEvents() {
        self.cloudService.startDownloadingObserver.subscribe(onNext: { [unowned self] event in
            switch event {
            case .next(let cloudItem):
                if self.viewModel.isContain(item: cloudItem) {
                    self.presenter.bind(viewModel: self.viewModel)
                }

            default:
                break
            }
        }).disposeOnDeactivate(interactor: self)

        self.cloudService.endDownloadingObserver.subscribe(onNext: { [unowned self] event in
            switch event {
            case .next(let cloudItem):
                if self.viewModel.isContain(item: cloudItem) {
                    self.presenter.bind(viewModel: self.viewModel)
                }

                self.listener?.openCloudDidDownloadSuccessfully()

            case .error(let error):
                self.presenter.showError(message: "Something wrong")
                if let data = (error as NSError).userInfo["data"] as? Data,
                   let json = try? JSONSerialization.jsonObject(with: data) {
                    TLLogging.log("Download file error: \(json)")
                } else {
                    TLLogging.log("Download file error: \(error)")
                }

                self.presenter.bind(viewModel: self.viewModel)

            default:
                break
            }
        }).disposeOnDeactivate(interactor: self)
    }

    private func fetchData() {
        self.presenter.showLoading()
        self.cloudService.fetch(item: self.cloudItem) { [weak self] items, error in
            guard let self = self else {
                return
            }

            self.presenter.dismissLoading()
            if let error = error {
                self.presenter.showError(message: "Something wrong")
                TLLogging.log("execute query error \(error)")
                return
            }

            self.viewModel.replace(items: items!)
            self.presenter.bind(viewModel: self.viewModel)
        }
    }
}

// MARK: - OpenDrivePresentableListener
extension OpenCloudInteractor: OpenCloudPresentableListener {
    func didSelectBack() {
        listener?.openCloudWantToDismiss()
    }

    func didSelectLogout() {
        listener?.openCloudWantToLogout()
    }

    func didSelectFolder(viewModel: OpenCloudItemViewModel) {
        self.router?.routeToOpenCloud(cloudItem: viewModel.item, parentId: self.viewModel.id, cloudService: self.cloudService)
    }

    func didSelectFile(itemViewModel: OpenCloudItemViewModel) {
        self.cloudService.download(item: itemViewModel.item)
    }
}

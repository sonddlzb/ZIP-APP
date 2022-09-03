//
//  SelectMediaInteractor.swift
//  Zip
//
//  Created by đào sơn on 03/09/2022.
//

import RIBs
import RxSwift
import Photos

protocol SelectMediaRouting: ViewableRouting {
    func removeViewControllerFromNavigation()
    func routeToPreviewImage(asset: PHAsset)
    func dismissPreviewImage()
    func routeToPreviewVideo(asset: PHAsset)
    func dismissPreviewVideo()
}

protocol SelectMediaPresentable: Presentable {
    var listener: SelectMediaPresentableListener? { get set }
    func bindMedia(viewModel: SelectMediaViewModel)
}

protocol SelectMediaListener: AnyObject {
    func selectMediaWantToDismiss()
    func selectMediaWantToCompress(assets: [PHAsset])
}

final class SelectMediaInteractor: PresentableInteractor<SelectMediaPresentable>, SelectMediaInteractable {

    weak var router: SelectMediaRouting?
    weak var listener: SelectMediaListener?

    var selectMediaViewModel: SelectMediaViewModel

    override init(presenter: SelectMediaPresentable) {
        self.selectMediaViewModel = SelectMediaViewModel.makeEmptyListAsset()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        fetchAsset(isNeedToUpdateSelectedState: false)
    }

    override func willResignActive() {
        super.willResignActive()
        self.router?.removeViewControllerFromNavigation()
    }

    func fetchAsset(isNeedToUpdateSelectedState: Bool) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                self.handleLoadingLibrary(authorizationStatus: status, isNeedToUpdateSelectedState: isNeedToUpdateSelectedState)
            }
        }
    }

    func handleLoadingLibrary(authorizationStatus: PHAuthorizationStatus, isNeedToUpdateSelectedState: Bool) {
        var listAssets: [PHAsset] = []
        if authorizationStatus == .authorized {
            self.selectMediaViewModel.isGrantedAccess = true
            let assets = PHAsset.fetchAssets(with: nil)
            assets.enumerateObjects { (object, _, _) in
                listAssets.append(object)
            }

            selectMediaViewModel.listAsset = listAssets
            self.selectMediaViewModel.listAsset = listAssets
            selectMediaViewModel.sortMediaFromNewestToOldest()
            if isNeedToUpdateSelectedState {
                self.selectMediaViewModel.updateIsPHAssetSelected()
            }

            presenter.bindMedia(viewModel: self.selectMediaViewModel)
        } else {
            self.selectMediaViewModel.isGrantedAccess = false
        }
    }
}

// MARK: SelectMediaPresentableListener
extension SelectMediaInteractor: SelectMediaPresentableListener {
    func didUnselectAll() {
        if self.selectMediaViewModel.numberOfSelectedItems() == 0 && !self.selectMediaViewModel.isOnSelectedMode {
            return
        }

        self.selectMediaViewModel.unSelectAll()
        self.selectMediaViewModel.isOnSelectedMode = false
        self.presenter.bindMedia(viewModel: selectMediaViewModel)
    }

    func didPress(on itemViewModel: SelectMediaItemViewModel) {
        if self.selectMediaViewModel.isItemSelected(itemViewModel) {
            self.selectMediaViewModel.unSelect(itemViewModel: itemViewModel)
        } else {
            self.selectMediaViewModel.select(itemViewModel: itemViewModel)
        }

        presenter.bindMedia(viewModel: selectMediaViewModel)
    }

    func didTapSelectAllButton() {
        if self.selectMediaViewModel.isSelectAll() {
            self.selectMediaViewModel.unSelectAll()
        } else {
            self.selectMediaViewModel.selectAll()
        }

        self.presenter.bindMedia(viewModel: selectMediaViewModel)
    }

    func didTapBackButton() {
        listener?.selectMediaWantToDismiss()
    }

    func didSelectOptionAction(_ action: OptionActionType) {
        if action == .compress {
            listener?.selectMediaWantToCompress(assets: self.selectMediaViewModel.selectedItems())
        }
    }

    func didGrantAccessToLibrary() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        presenter.bindMedia(viewModel: self.selectMediaViewModel)
    }

    func didLongPressToPreview(asset: PHAsset) {
        guard !self.selectMediaViewModel.isOnSelectedMode else {
            return
        }

        if asset.mediaType == .image {
            router?.routeToPreviewImage(asset: asset)
        } else {
            router?.routeToPreviewVideo(asset: asset)
        }
    }

    func applicationWillEnterForeground() {
        fetchAsset(isNeedToUpdateSelectedState: true)
    }
}

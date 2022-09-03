//
//  SelectMediaViewModel.swift
//  Zip
//
//  Created by đào sơn on 20/06/2022.
//

import Foundation
import Photos
import UIKit

struct SelectMediaViewModel {
    var listAsset: [PHAsset]
    private var isPHAssetSelected: [PHAsset: Bool]
    var isGrantedAccess = true
    var isOnSelectedMode = false

    static func makeEmptyListAsset() -> SelectMediaViewModel {
        return SelectMediaViewModel(listAsset: [], isPHAssetSelected: [:])
    }

    // MARK: - Getter
    func item(at index: Int) -> SelectMediaItemViewModel {
        return SelectMediaItemViewModel(asset: listAsset[index], isSelected: self.isPHAssetSelected[listAsset[index]] ?? false)
    }

    func numberOfAsset() -> Int {
        return listAsset.count
    }

    func numberOfSelectedItems() -> Int {
        return isPHAssetSelected.filter({ $0.value }).count
    }

    func isItemSelected(_ itemViewModel: SelectMediaItemViewModel) -> Bool {
        return isPHAssetSelected[itemViewModel.asset] ?? false
    }

    func isSelectAll() -> Bool {
        return self.listAsset.count == self.numberOfSelectedItems()
    }

    func selectedItems() -> [PHAsset] {
        return isPHAssetSelected.filter({ $0.value }).map({ $0.key })
    }

    func selectAllImage() -> UIImage? {
        return isSelectAll() ? UIImage(named: "rd_unselected") : UIImage(named: "rd_selected")
    }

    func titleContent() -> String {
        return self.numberOfSelectedItems() == 0 && !isOnSelectedMode ? "Library" : "Selected (\(self.numberOfSelectedItems()))"
    }

    func backButtonImage() -> UIImage? {
        return self.numberOfSelectedItems() == 0 && !isOnSelectedMode ? UIImage(named: "icon-back") : UIImage(named: "icon-cancel")
    }

    func listItemViewModel() -> [SelectMediaItemViewModel] {
        return self.listAsset.map { asset in
            SelectMediaItemViewModel(asset: asset, isSelected: self.isPHAssetSelected[asset] ?? false)
        }
    }

    func isOptionViewVisible() -> Bool {
        return self.isOnSelectedMode && self.numberOfSelectedItems() > 0
    }

    // MARK: - Interactor
    mutating func select(itemViewModel: SelectMediaItemViewModel) {
        isPHAssetSelected[itemViewModel.asset] = true
        self.isOnSelectedMode = true
    }

    mutating func unSelect(itemViewModel: SelectMediaItemViewModel) {
        isPHAssetSelected[itemViewModel.asset] = false
    }

    mutating func selectAll() {
        self.isPHAssetSelected = [:]
        self.listAsset.forEach({ self.isPHAssetSelected[$0] = true })
        self.isOnSelectedMode = true
    }

    mutating func unSelectAll() {
        self.isPHAssetSelected = [:]
    }

    mutating func sortMediaFromNewestToOldest() {
        self.listAsset.sort {
            return $0.creationDate ?? Date() > $1.creationDate ?? Date()
        }
    }

    mutating func updateIsPHAssetSelected() {
        var isSelected: [PHAsset: Bool] = [:]
        for pHAsset in self.listAsset {
            if isPHAssetSelected[pHAsset] ?? false {
                isSelected[pHAsset] = true
            }
        }

        if isSelected.count == 0 {
            self.isOnSelectedMode = false
        }

        self.isPHAssetSelected = isSelected
    }
}

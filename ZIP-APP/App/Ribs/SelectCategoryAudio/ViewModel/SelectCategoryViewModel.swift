//
//  SelectCategoryViewModel.swift
//  Zip
//
//

import Foundation
import MediaPlayer

struct SelectCategoryViewModel {
    var categories: [MPMediaItemCollection]

    func numberOfItems() -> Int {
        return categories.count
    }

    func item(at index: Int) -> SelectCategoryItemViewModel {
        return SelectCategoryItemViewModel(category: categories[index])
    }

    func isEmpty() -> Bool {
        return categories.isEmpty
    }
}

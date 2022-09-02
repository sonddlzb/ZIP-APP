//
//  OptionViewModel.swift
//  Zip
//
//

import Foundation

struct OptionViewModel {
    var options: [OptionActionType]

    static func makeEmpty() -> OptionViewModel {
        return OptionViewModel(options: [])
    }

    func numberOfPage() -> Int {
        return Set(options.map({$0.priority()})).count
    }

    func numberOfItems(in page: Int) -> Int {
        return options.filter({$0.priority() == page}).count
    }

    func item(at index: Int, page: Int) -> OptionItemViewModel {
        let optionsInPage = options.filter({$0.priority() == page})
        return OptionItemViewModel(actionType: optionsInPage[index], isHorizontal: optionsInPage.count < 2)
    }

    func firstIndex(ofPage index: Int) -> Int {
        return options.firstIndex(where: {$0.priority() == index}) ?? 0
    }

    func isEmpty() -> Bool {
        return self.options.isEmpty
    }
}

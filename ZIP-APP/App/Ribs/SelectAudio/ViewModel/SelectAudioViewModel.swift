//
//  SelectAudioViewModel.swift
//  Zip
//
//

import Foundation
import MediaPlayer

struct SelectAudioViewModel {
    var collection: MPMediaItemCollection?
    var playingItem: MPMediaItem?
    var isSelectingModeEnabled: Bool
    private var items: [MPMediaItem] = []
    private var selectedTable: [UInt64: Bool]

    init(collection: MPMediaItemCollection, playingItem: MPMediaItem? = nil, isSelectingModeEnabled: Bool = false) {
        self.collection = collection
        selectedTable = [:]
        self.items = []
        self.playingItem = playingItem
        self.isSelectingModeEnabled = isSelectingModeEnabled
        collection.items.forEach({ self.items.append($0) })
    }

    // MARK: - Getter
    func numberOfItems() -> Int {
        return self.items.count
    }

    func item(at index: Int) -> SelectAudioItemViewModel {
        let item = self.items[index]
        return SelectAudioItemViewModel(audioItem: item,
                                        isSelected: selectedTable[item.persistentID] ?? false,
                                        isPlaying: playingItem?.persistentID == item.persistentID)
    }

    func isItemSelected(_ item: MPMediaItem) -> Bool {
        return self.selectedTable[item.persistentID] ?? false
    }

    func imageForSelectAllButton() -> UIImage {
        return UIImage(named: self.isSelectedAll() ? "rd_unselected" : "rd_selected")!
    }

    func numberOfSelected() -> Int {
        return self.selectedTable.filter({ $0.value }).count
    }

    func title() -> String {
        if isSelectingModeEnabled {
            return "Selected (\(self.numberOfSelected()))"
        }

        if let collectionName = collection?.representativeItem?.value(forProperty: MPMediaItemPropertyArtist) as? String,
           !collectionName.trim().isEmpty {
            return collectionName.trim()
        }

        return "New folder"
    }

    func imageForBackButton() -> UIImage {
        return UIImage(named: isSelectingModeEnabled ? "ic_close" : "ic_back")!
    }

    func selectedItems() -> [MPMediaItem] {
        return self.items.filter({ self.selectedTable[$0.persistentID] == true })
    }

    func isSelectedAll() -> Bool {
        return self.numberOfItems() == self.numberOfSelected() && self.hasItemSelected()
    }

    func hasItemSelected() -> Bool {
        return self.numberOfSelected() > 0
    }

    func listItemViewModels() -> [SelectAudioItemViewModel] {
        return self.items.enumerated().map({
            self.item(at: $0.offset)
        })
    }

    // MARK: - Interactor
    mutating func reverseSelectedState(item: MPMediaItem) {
        if self.isItemSelected(item) {
            self.unselect(item: item)
        } else {
            self.select(item: item)
        }
    }

    mutating func select(item: MPMediaItem) {
        self.selectedTable[item.persistentID] = true
        self.isSelectingModeEnabled = true
    }

    mutating func unselect(item: MPMediaItem) {
        self.selectedTable[item.persistentID] = false
    }

    mutating func selectAll() {
        self.items.forEach({ self.selectedTable[$0.persistentID] = true })
        self.isSelectingModeEnabled = true
    }

    mutating func unselectAll() {
        self.selectedTable = [:]
    }

    mutating func refresh() {
        guard let newCollection = MPMediaQuery.artists().collections?.first(where: { $0.persistentID == self.collection?.persistentID }) else {
            self.collection = nil
            self.selectedTable = [:]
            self.isSelectingModeEnabled = false
            self.playingItem = nil
            return
        }

        self.collection = newCollection
        self.items = []
        newCollection.items.forEach({ self.items.append($0) })

        self.selectedTable.keys.filter { key in
            !newCollection.items.contains(where: {$0.persistentID == key})
        }.forEach({ self.selectedTable.removeValue(forKey: $0) })

        if self.numberOfSelected() == 0 {
            self.isSelectingModeEnabled = false
        }

        if let playingItem = playingItem,
           self.items.contains(where: {$0.persistentID == playingItem.persistentID}) {
            self.playingItem = nil
        }
    }
}

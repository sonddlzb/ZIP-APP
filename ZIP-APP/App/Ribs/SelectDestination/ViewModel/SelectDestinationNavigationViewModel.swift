//
//  SelectDestinationNavigationViewModel.swift
//  Zip
//
//

import Foundation

struct SelectDestinationNavigationViewModel {
    var url: URL
    var components: [String]

    init(url: URL) {
        self.url = url
        let myfileComponents = FileManager.myFileURL().pathComponents
        components = self.url.pathComponents.filter({ !myfileComponents.contains($0) })
        components.insert("My File", at: 0)
    }

    func numberOfComponents() -> Int {
        return components.count
    }

    func text(at index: Int) -> String {
        if index == 0 {
            return components[0] + " "
        }

        return "/ \(components[index])"
    }

    func url(at index: Int) -> URL {
        var currentURL = FileManager.myFileURL()
        for currentIndex in 1 ..< index + 1 {
            currentURL.appendPathComponent(components[currentIndex])
        }

        return currentURL
    }
}

//
//  AppComponent.swift
//  Zip
//
//

import Foundation
import RIBs

class AppComponent: Component<EmptyDependency>, RootDependency {
    var window: UIWindow

    init(window: UIWindow) {
        self.window = window
        super.init(dependency: EmptyComponent())
    }
}

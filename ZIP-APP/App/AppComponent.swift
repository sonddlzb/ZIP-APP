//
//  AppComponent.swift
//  Zip
//
//  Created by Linh Nguyen Duc on 20/06/2022.
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

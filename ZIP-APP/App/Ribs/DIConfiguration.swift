//
//  DIConfiguration.swift
//  Zip
//
//  Created by Linh Nguyen Duc on 23/05/2022.
//

import Foundation
import Resolver

extension DIConnector {
    static func registerAllRibs() {
        DIContainer.register(RootBuildable.self) { _, args in
            return RootBuilder(dependency: args.get())
        }

        DIContainer.register(HomeBuildable.self) { _, args in
            return HomeBuilder(dependency: args.get())
        }
    }
}

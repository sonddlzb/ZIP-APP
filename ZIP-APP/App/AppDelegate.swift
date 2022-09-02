//
//  AppDelegate.swift
//  Zip
//
//

import UIKit

import SVProgressHUD
import TLLogging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow!
    var rootRouter: RootRouting?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DIConnector.registerAllDeps()
        self.configLoading()
        self.configLogging()
        self.configWindow()
        self.configAppearance()
        return true
    }

    // MARK: - Config


    private func configLogging() {
        TLLogging.addLogEngine(TLConsoleLogEngine())
    }

    private func configWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()

        let appComponent = AppComponent(window: self.window)
        let rootBuilder = DIContainer.resolve(RootBuildable.self, agrument: appComponent)
        rootRouter = rootBuilder.build()
        rootRouter?.interactable.activate()
    }

    private func configLoading() {
        SVProgressHUD.setDefaultMaskType(.black)
    }

    private func configAppearance() {
        UIView.appearance().isExclusiveTouch = true
        UIView.appearance().isMultipleTouchEnabled = false

        if #available(iOS 13.0, *) {
            UIView.appearance().overrideUserInterfaceStyle = .light
        }
    }
}

//
//  BaseViewController.swift
//  Core
//
//

import UIKit
import RxSwift

open class BaseViewControler: UIViewController {
    private var viewWillAppeared: Bool = false
    private var viewDidAppeared: Bool = false
    public var isDisplaying: Bool = false
    var disposeBag = DisposeBag()

    // MARK: - Life cycle
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        (self.navigationController as? BaseNavigationController)?.refreshInteractivePopGestureState()

        if !viewWillAppeared {
            viewWillAppeared = true
            self.viewWillFirstAppear()
        }
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isDisplaying = true
        if !viewDidAppeared {
            viewDidAppeared = true
            self.viewDidFirstAppear()
        }
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isDisplaying = false
    }

    open func viewWillFirstAppear() {
        // nothing
    }

    open func viewDidFirstAppear() {
        // nothing
    }

    open func viewWillDisappearByInteractive() {
        // nothing
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    public var isInteractivePopGestureEnabled: Bool {
        return true
    }

    // MARK: - Alert
    public func showAlert(title: String = "", message: String = "", titleButtons: [String] = ["OK"], destructiveIndexs: [Int] = [], action: ((Int) -> Void)? = nil) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        titleButtons.forEach { (titleButton) in
            let index = titleButtons.firstIndex(of: titleButton)!
            let style = destructiveIndexs.contains(index) ? UIAlertAction.Style.destructive : UIAlertAction.Style.default
            let alertAction = UIAlertAction.init(title: titleButton, style: style, handler: { (_) in
                action?(index)
            })

            alert.addAction(alertAction)
        }

        self.present(alert, animated: true, completion: nil)
    }

    public func showAlertEdit(title: String = "", message: String = "", oldValue: String = "", titleButtons: [String] = ["OK"], action: ((Int, String) -> Void)? = nil) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addTextField { (textField) in
            textField.text = oldValue
        }

        titleButtons.forEach { (titleButton) in
            let index = titleButtons.firstIndex(of: titleButton)!
            let alertAction = UIAlertAction.init(title: titleButton, style: UIAlertAction.Style.default, handler: { (_) in

                let textField = alert.textFields?.first!
                action?(index, textField?.text ?? "")
            })

            alert.addAction(alertAction)
        }

        self.present(alert, animated: true, completion: nil)
    }
}

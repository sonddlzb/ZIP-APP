//
//  RootViewController.swift
//  Zip
//
//  Created by Linh Nguyen Duc on 20/06/2022.
//

import RIBs
import RxSwift
import UIKit

protocol RootPresentableListener: AnyObject {
}

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {
    weak var listener: RootPresentableListener?
}

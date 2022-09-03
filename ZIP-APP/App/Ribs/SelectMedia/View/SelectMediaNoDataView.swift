//
//  SelectMediaNoDataView.swift
//  Zip
//
//  Created by đào sơn on 06/07/2022.
//

import Foundation
import UIKit

class SelectMediaNoDataView: UIView {
    static func loadView() -> SelectMediaNoDataView {
        let view = SelectMediaNoDataView.loadView(fromNib: "SelectMediaNoDataView")!
        return view
    }
}

//
//  UINavigationController+Ext.swift
//  BaseConverter
//
//  Created by DaiTran on 8/1/20.
//  Copyright © 2020 Dai Tran. All rights reserved.
//

import UIKit

extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        topViewController
    }
}

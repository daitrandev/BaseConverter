//
//  UITraitCollector+Utils.swift
//  BaseConverter
//
//  Created by DaiTran on 7/22/20.
//  Copyright © 2020 Dai Tran. All rights reserved.
//

import UIKit

@available(iOS 12.0, *)
extension UIUserInterfaceStyle {
    var themeColor: UIColor {
        switch self {
        case .light, .unspecified:
            return .deepBlue
            
        case .dark:
            return .orange
            
        @unknown default:
            return .deepBlue
        }
    }
}

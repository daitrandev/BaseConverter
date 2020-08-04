//
//  UIImageview+Utils.swift
//  BaseConverter
//
//  Created by DaiTran on 8/1/20.
//  Copyright © 2020 Dai Tran. All rights reserved.
//

import UIKit

extension UIImageView {
    func set(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

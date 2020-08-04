//
//  Character+Ext.swift
//  BaseConverter
//
//  Created by DaiTran on 8/1/20.
//  Copyright © 2020 Dai Tran. All rights reserved.
//

extension Character {
    var asciiValue: UInt32? {
        return String(self).unicodeScalars.filter{$0.isASCII}.first?.value
    }
}

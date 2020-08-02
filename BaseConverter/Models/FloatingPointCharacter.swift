//
//  FloatingPointCharacter.swift
//  BaseConverter
//
//  Created by DaiTran on 8/1/20.
//  Copyright © 2020 Dai Tran. All rights reserved.
//

enum FloatingPointCharacter: String, CaseIterable {
    case dot = "."
    case comma = ","
    
    init?(string: String) {
        for floatingPointChar in Self.allCases {
            if string.contains(floatingPointChar.rawValue) {
                self = floatingPointChar
            }
        }
        return nil
    }
}

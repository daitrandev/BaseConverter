//
//  CommonBase.swift
//  BaseConverter
//
//  Created by Dai Tran on 4/20/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

enum CommonBase: Int {
    case binaryCode = 2
    case octalCode = 8
    case decimalCode = 10
    case hexaCode = 16
    
    var name: String {
        switch self {
        case .binaryCode:
            return "BIN"
            
        case .octalCode:
            return "OCT"
            
        case .decimalCode:
            return "DEC"
            
        case .hexaCode:
            return "HEX"
        }
    }
    
    var allowingCharacters: String? {
        switch self {
        case .binaryCode:
            return "01 "
            
        case .octalCode:
            return "01234567 "
            
        case .decimalCode:
            return "0123456789 "
            
        case .hexaCode:
            return "0123456789aAbBcCdDeEfF "
        }
    }
}


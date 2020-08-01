//
//  BaseConverter.swift
//  BaseConverter
//
//  Created by Dai Tran on 4/23/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit

class BaseConverter {
    static func convertFloatingNumToBase10(floating num: String?, from baseNum: Int) -> String? {
        
        guard let num = num else { return nil }
        
        let calculateOperand: ((Character, Int) -> Double?) = { (numChar, exponent) in
            var num: Double? = Double(String(numChar))
            
            if num == nil {
                guard let asciiValue = numChar.asciiValue else { return nil }
                num = Double(asciiValue - 55)
            }
            let baseExponent = pow(Double(baseNum), Double(exponent))
            if let num = num {
                return num * baseExponent
            }
            return nil
        }
        
        var base10Str = ""
        var sum: Double = 0
        
        let charSet = CharacterSet(charactersIn: ".,")
        let lhs = num.components(separatedBy: charSet)[0]
        let rhs = num.components(separatedBy: charSet)[1]
        
        var leftCount = lhs.count - 1
        for numChar in lhs {
            guard let operand = calculateOperand(numChar, leftCount) else { return nil }
            sum += operand
            leftCount -= 1
        }
        
        base10Str += String(Int(sum))
        
        sum = 0
        var rightCount = -1
        for numChar in rhs {
            guard let operand = calculateOperand(numChar, rightCount) else { return nil }
            sum += operand
            rightCount -= 1
        }
        
        let strNum = String(sum)
        let index = strNum.index(strNum.startIndex, offsetBy: 1)
        base10Str += strNum[index...]
        
        return base10Str
    }
    
    static func convertFromBase10FloatingPoint(floating num: String?, to baseNum: Int, hasComma: Bool) -> String? {
        guard let num = num else {
            return nil
        }
        
        
        let charSet = CharacterSet(charactersIn: ".,")
        let lhs = num.components(separatedBy: charSet)[0]
        let rhs = num.components(separatedBy: charSet)[1]
        
        guard let lhsNum = Int(lhs) else { return nil }
        
        let seperateCharacter = hasComma ? "," : "."
        guard var rhsNum = Double("0." + rhs) else { return nil }
        
        var baseStr = String(lhsNum, radix: baseNum).uppercased() + seperateCharacter
        
        var decimalPlaces = 20
        
        repeat {
            rhsNum *= Double(baseNum)
            
            if rhsNum > 10 {
                let index = alphabet.index(alphabet.startIndex, offsetBy: Int(rhsNum) - 10)
                baseStr += String(alphabet[index])
            } else {
                baseStr += String(Int(rhsNum))
            }
            rhsNum -= Double(Int(rhsNum))
            decimalPlaces -= 1
        } while decimalPlaces > 0 && rhsNum != 0
        
        return baseStr
    }
    
}

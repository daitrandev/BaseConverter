//
//  AllBasesTableViewCell.swift
//  BaseConverter
//
//  Created by Dai Tran on 4/22/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit

class AllBasesTableViewCell: CommonBasesTableViewCell {
    
    let numAndAlphabet: String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        baseNums.removeAll()
        baseTexts.removeAll()
        allowingCharacters.removeAll()

        var string = "0"
        let baseString = NSLocalizedString("Base", comment: "")
        for i in 2...36 {
            let baseText = baseString + " \(i)"
            baseTexts.append(baseText)
            baseNums.append(i)

            let index = numAndAlphabet.index(numAndAlphabet.startIndex, offsetBy: i - 1)
            string += String(numAndAlphabet[index])
            if i > 10 {
                string += String(numAndAlphabet[index]).lowercased()
            }

            allowingCharacters.append(string)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

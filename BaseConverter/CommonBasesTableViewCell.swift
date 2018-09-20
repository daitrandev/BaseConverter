//
//  MainTableViewCell.swift
//  BaseConverter
//
//  Created by Dai Tran on 4/22/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit

protocol CommonTableViewCellDataSource: class {
    func updateAllBases(bases: [Base], excepted tag: Int)
}

class CommonBasesTableViewCell: UITableViewCell {
    
    var allowingCharacters = ["01 ", "01234567 ", "0123456789 ", "0123456789aAbBcCdDeEfF "]
    
    var baseNums = [2, 8, 10, 16]
    
    var baseTexts = ["BIN", "OCT", "DEC", "HEX"]
        
    weak var delegate: CommonTableViewCellDataSource?
    
    var base: Base? {
        didSet {
            let isLightTheme = UserDefaults.standard.bool(forKey: isLightThemeKey)
            self.backgroundColor = isLightTheme ? UIColor.white : UIColor.black
            
            guard let base = base else { return }
            
            baseLabel.text      = base.baseLabelText
            baseTextField.tag   = base.baseTextFieldTag
            baseTextField.text  = base.baseTextFieldText
            baseTextField.keyboardType = baseNums[baseTextField.tag] < 11 ? .decimalPad : .numbersAndPunctuation
            
            let baseNum = baseNums[baseTextField.tag]
            let baseString = NSLocalizedString("Base", comment: "")
            let attributedPlaceHolder = NSMutableAttributedString()
            attributedPlaceHolder.append(NSAttributedString(string: baseString + " \(baseNum)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            baseTextField.attributedPlaceholder = attributedPlaceHolder

            guard let baseTextFieldText = base.baseTextFieldText else { return }
            if baseTextFieldText.contains(Character(".")) || baseTextFieldText.contains(Character(",")) {
                let decimalPlaces = UserDefaults.standard.integer(forKey: decimalPlaceKey)
                let lhs = baseTextFieldText.components(separatedBy: CharacterSet.init(charactersIn: ".,"))[0]
                let rhs = baseTextFieldText.components(separatedBy: CharacterSet.init(charactersIn: ".,"))[1]
                var endIndex = baseTextFieldText.index(rhs.startIndex, offsetBy: decimalPlaces, limitedBy: rhs.endIndex)
                if endIndex == nil {
                    endIndex = rhs.endIndex
                }
                let seperateCharacter = baseTextFieldText.contains(Character(".")) ? "." : ","
                baseTextField.text = lhs + seperateCharacter + rhs[..<endIndex!]
            }
        }
    }
    
    let baseLabel: UILabel = {
        let label = UILabel()
        label.text = "Base"
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.textColor = .white
        label.backgroundColor = UserDefaults.standard.bool(forKey: isLightThemeKey) ? .deepBlue : .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var baseTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 5
        textField.textAlignment = .center
        textField.layer.masksToBounds = true
        textField.backgroundColor = .white
        textField.layer.borderColor = UserDefaults.standard.bool(forKey: isLightThemeKey) ? UIColor.deepBlue.cgColor : UIColor.orange.cgColor
        textField.returnKeyType = .done
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    @objc func textFieldEditingChanged(textField: UITextField) {
        guard let newString = textField.text?.components(separatedBy: .whitespacesAndNewlines).joined() else { return }
        textField.text = newString.uppercased()
                
        let base10 = Int(newString, radix: baseNums[textField.tag])
        
        var hasComma = false
        
        var isValidFloatingPoint = false
        
        if textField.text!.contains(Character(".")) && textField.text?.last != "." {
            isValidFloatingPoint = true
        } else if textField.text!.contains(Character(",")) && textField.text?.last != "," {
            isValidFloatingPoint = true
            hasComma = true
        }
        
        let base10FloatingPoint = !isValidFloatingPoint ? nil : Utilities.convertFloatingNumToBase10(floating: textField.text, from: baseNums[textField.tag])
        
        var bases: [Base] = []
        for i in 0..<baseNums.count {
            if i == textField.tag {
                let base = Base(baseLabelText: "\(baseTexts[i])", baseTextFieldTag: i, baseTextFieldText: textField.text)
                bases.append(base)
                continue
            }
            
            var baseTextFieldText: String?
            if let base10 = base10 {
                baseTextFieldText = String(base10, radix: baseNums[i]).uppercased()
            } else {
                baseTextFieldText = Utilities.convertFromBase10FloatingPoint(floating: base10FloatingPoint, to: baseNums[i], hasComma: hasComma)
            }
            
            let base = Base(baseLabelText: "\(baseTexts[i])", baseTextFieldTag: i, baseTextFieldText: baseTextFieldText)
            bases.append(base)
            
        }
        
        delegate?.updateAllBases(bases: bases, excepted: textField.tag)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let isLightTheme = UserDefaults.standard.bool(forKey: isLightThemeKey)
        self.backgroundColor = isLightTheme ? UIColor.white : UIColor.black
        
        addSubview(baseLabel)
        addSubview(baseTextField)
        
        baseLabel.constraintTo(top: topAnchor, bottom: bottomAnchor, left: contentView.leftAnchor, right: nil, topConstant: 8, bottomConstant: -8, leftConstant: 8, rightConstant: -8)
        baseLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        
        baseTextField.constraintTo(top: topAnchor, bottom: bottomAnchor, left: baseLabel.rightAnchor, right: contentView.rightAnchor, topConstant: 8, bottomConstant: -8, leftConstant: 8, rightConstant: -8)
        
    }
    
    func updateLabelColor() {
        let isLightTheme = UserDefaults.standard.bool(forKey: isLightThemeKey)
        baseLabel.backgroundColor = isLightTheme ? UIColor.deepBlue : UIColor.orange
        baseTextField.layer.borderColor = isLightTheme ? UIColor.deepBlue.cgColor : UIColor.orange.cgColor
    }
}

extension CommonBasesTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string == "." || string == "," {
            var isFloatingPoint = false
            
            if textField.text!.contains(Character(".")) {
                isFloatingPoint = true
            } else if textField.text!.contains(Character(",")) {
                isFloatingPoint = true
            }
            return !isFloatingPoint
        }
        
        for char in string {
            if (!allowingCharacters[textField.tag].contains(char)) {
                return false
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let isLightTheme = UserDefaults.standard.bool(forKey: "isLightTheme")
        textField.keyboardAppearance = isLightTheme ? .light : .dark
        return true
    }
}

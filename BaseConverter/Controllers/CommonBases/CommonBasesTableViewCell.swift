//
//  MainTableViewCell.swift
//  BaseConverter
//
//  Created by Dai Tran on 4/22/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit

protocol CommonTableViewCellDelegate: class {
    func updateAllBases(bases: [Base], excepted tag: Int)
    func presentCopiedAlert(message: String)
}

class CommonBasesTableViewCell: UITableViewCell {
    
    var allowingCharacters = ["01 ", "01234567 ", "0123456789 ", "0123456789aAbBcCdDeEfF "]
    
    var baseNums = [2, 8, 10, 16]
    
    var baseTexts = ["BIN", "OCT", "DEC", "HEX"]
        
    weak var delegate: CommonTableViewCellDelegate?
    
    var base: Base? {
        didSet {
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
        }
    }
    
    private let baseLabel: UILabel = {
        let label = UILabel()
        label.text = "Base"
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var baseTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 10
        textField.textAlignment = .center
        textField.layer.masksToBounds = true
        textField.backgroundColor = .white
        textField.returnKeyType = .done
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var copyButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        let buttonImage = UIImage(named: "copy")
        button.setImage(buttonImage, for: .normal)
        button.addTarget(self, action: #selector(didTapCopy), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        setupColor()
        
        addSubview(baseLabel)
        addSubview(baseTextField)
        
        baseLabel.constraintTo(
            top: topAnchor,
            bottom: nil,
            left: contentView.leftAnchor,
            right: nil,
            topConstant: 8,
            bottomConstant: -8,
            leftConstant: 8,
            rightConstant: -8
        )
        baseLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        addSubview(copyButton)
        
        baseTextField.constraintTo(
            top: baseLabel.bottomAnchor,
            bottom: contentView.bottomAnchor,
            left: contentView.leftAnchor,
            right: copyButton.leftAnchor,
            topConstant: 8,
            bottomConstant: -8,
            leftConstant: 8,
            rightConstant: -8
        )
        
        copyButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        copyButton.centerYAnchor.constraint(equalTo: baseTextField.centerYAnchor).isActive = true
        copyButton.widthAnchor.constraint(equalTo: copyButton.heightAnchor).isActive = true
        copyButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    @objc func didTapCopy() {
        if baseTextField.text != "" {
            UIPasteboard.general.string = baseTextField.text!
            delegate?.presentCopiedAlert(message: NSLocalizedString("Copied", comment: ""))
        } else {
            delegate?.presentCopiedAlert(message: NSLocalizedString("Nothing to copy", comment: ""))
        }
    }
    
    private func setupColor() {
        if #available(iOS 13, *) {
            baseLabel.textColor = traitCollection.userInterfaceStyle.themeColor
            baseTextField.layer.borderColor = traitCollection.userInterfaceStyle.themeColor.cgColor
            copyButton.imageView?.set(color: traitCollection.userInterfaceStyle.themeColor)
        } else {
            baseLabel.textColor = .deepBlue
            baseTextField.layer.borderColor = UIColor.deepBlue.cgColor
            copyButton.imageView?.set(color: .deepBlue)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupColor()
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

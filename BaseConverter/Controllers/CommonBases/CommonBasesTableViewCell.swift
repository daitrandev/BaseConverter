//
//  MainTableViewCell.swift
//  BaseConverter
//
//  Created by Dai Tran on 4/22/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit

protocol CommonTableViewCellDelegate: class {
    func didChange(value: String, from baseValue: Int)
    func presentCopiedAlert(message: String)
}

class CommonBasesTableViewCell: UITableViewCell {
    @IBOutlet weak var baseLabel: UILabel!
    @IBOutlet weak var baseTextField: UITextField!
    @IBOutlet weak var copyButton: UIButton!
    
    private var baseValue: Int?
    private var allowingCharacters: String?
    
    private var placeholderColor: UIColor {
        if #available(iOS 13, *) {
            return .systemGray
        }
        
        return .gray
    }
    
    weak var delegate: CommonTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupColor()
        baseTextField.delegate = self
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
        
        baseTextField.textColor = .black
        baseTextField.backgroundColor = .white
    }
    
    @IBAction func textFieldEditingChanged() {
        guard
            let newString = baseTextField.text?.components(separatedBy: .whitespacesAndNewlines).joined(),
            let baseValue = baseValue else { return }
        baseTextField.text = newString.uppercased()
        
        delegate?.didChange(
            value: baseTextField.text!,
            from: baseValue
        )
    }
    
    @IBAction func didTapCopy() {
        UIPasteboard.general.string = baseTextField.text!
        delegate?.presentCopiedAlert(message: "Copied")
    }
    
    func configure(with item: CommonBasesViewModel.CellLayoutItem) {
        baseLabel.text = item.base.name
        baseTextField.text = item.content
        
        let attributedPlaceHolder = NSMutableAttributedString()
        attributedPlaceHolder.append(
            NSAttributedString(
                string: "Base \(item.base.rawValue)",
                attributes: [
                    NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 14) as Any,
                    NSAttributedString.Key.foregroundColor: placeholderColor
                ]
            )
        )
        baseTextField.attributedPlaceholder = attributedPlaceHolder
        baseValue = item.base.rawValue
        allowingCharacters = item.base.allowingCharacters
        
        if item.base.rawValue <= 10 {
            baseTextField.keyboardType = .decimalPad
        } else {
            baseTextField.keyboardType = .numbersAndPunctuation
        }
    }
    
    func configure(with item: AllBasesViewModel.CellLayoutItem) {
        baseLabel.text = "Base \(item.baseValue)"
        baseTextField.text = item.content
        
        let attributedPlaceHolder = NSMutableAttributedString()
        attributedPlaceHolder.append(
            NSAttributedString(
                string: "Base \(item.baseValue)",
                attributes: [
                    NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 14) as Any,
                    NSAttributedString.Key.foregroundColor: placeholderColor
                ]
            )
        )
        baseTextField.attributedPlaceholder = attributedPlaceHolder
        baseValue = item.baseValue
        allowingCharacters = item.allowingCharacters
        
        if item.baseValue <= 10 {
            baseTextField.keyboardType = .decimalPad
        } else {
            baseTextField.keyboardType = .numbersAndPunctuation
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupColor()
    }
}

extension CommonBasesTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if string == "." || string == "," {
            if textField.text!.contains(Character(".")) {
                return false
            }
            
            if textField.text!.contains(Character(",")) {
                return false
            }
            return true
        }
        
        let uppercaseString = string.uppercased()
        for char in uppercaseString {
            if (allowingCharacters?.uppercased().contains(char) == false) {
                return false
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

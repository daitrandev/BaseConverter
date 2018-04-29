//
//  SettingViewController.swift
//  BaseConverter
//
//  Created by Dai Tran on 4/23/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    lazy var decimalPlacesPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    let decimalPlacesLabel: UILabel = {
        let label = UILabel()
        label.text = "Decimal Places:"
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var decimalPlacesStackViews: UIStackView = {
        let stackViews = UIStackView(arrangedSubviews: [decimalPlacesLabel, decimalPlacesPickerView])
        stackViews.axis = .horizontal
        stackViews.spacing = 10
        stackViews.translatesAutoresizingMaskIntoConstraints = false
        return stackViews
    }()
    
    let themes = [NSLocalizedString("LightTheme", comment: ""),
                  NSLocalizedString("DarkTheme", comment: "")]
    
    lazy var themePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()

    let themeLabel: UILabel = {
        let label = UILabel()
        label.text = "Theme:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var themeStackViews: UIStackView = {
        let stackViews = UIStackView(arrangedSubviews: [themeLabel, themePickerView])
        stackViews.axis = .horizontal
        stackViews.spacing = 10
        stackViews.translatesAutoresizingMaskIntoConstraints = false
        return stackViews
    }()
    
    var decimalPlaces: Int = UserDefaults.standard.integer(forKey: decimalPlaceKey)
    var isLightTheme: Bool = UserDefaults.standard.bool(forKey: isLightThemeKey)
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(decimalPlaces, forKey: decimalPlaceKey)
        UserDefaults.standard.set(isLightTheme, forKey: isLightThemeKey)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTheme()
    }
    
    override func viewDidLoad() {
        setupViews()
    }
    
    func setupViews() {
        
        view.backgroundColor = .white
        view.addSubview(decimalPlacesStackViews)
        view.addSubview(themeStackViews)
        
        decimalPlacesStackViews.constraintTo(top: view.layoutMarginsGuide.topAnchor, bottom: nil, left: view.layoutMarginsGuide.leftAnchor, right: view.layoutMarginsGuide.rightAnchor, topConstant: 8, bottomConstant: 0, leftConstant: 8, rightConstant: -8)
        decimalPlacesStackViews.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        decimalPlacesPickerView.widthAnchor.constraint(equalTo: decimalPlacesStackViews.widthAnchor, multiplier: 0.5).isActive = true
        
        themeStackViews.constraintTo(top: decimalPlacesStackViews.bottomAnchor, bottom: nil, left: view.layoutMarginsGuide.leftAnchor, right: view.layoutMarginsGuide.rightAnchor, topConstant: 8, bottomConstant: 0, leftConstant: 8, rightConstant: -8)
        themeStackViews.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        themePickerView.widthAnchor.constraint(equalTo: themeStackViews.widthAnchor, multiplier: 0.5).isActive = true
        
        let selectedRowTheme = isLightTheme ? 0 : 1
        themePickerView.selectRow(selectedRowTheme, inComponent: 0, animated: false)
        decimalPlacesPickerView.selectRow(decimalPlaces - 1, inComponent: 0, animated: false)
        
        decimalPlacesLabel.text = NSLocalizedString("DecimalPlaces", comment: "")
        themeLabel.text = NSLocalizedString("Theme", comment: "")
        navigationItem.title = NSLocalizedString("Settings", comment: "")

    }
    
    func loadTheme() {
        
        let labelArray: [UILabel] = [decimalPlacesLabel, themeLabel]
        let pickerViewArray: [UIPickerView] = [decimalPlacesPickerView, themePickerView]
        
        view.backgroundColor = isLightTheme ? UIColor.white : UIColor.black
        
        if (isLightTheme) {
            UIApplication.shared.statusBarStyle = .default
            
            navigationController?.navigationBar.tintColor = UIColor.deepBlue
        } else {
            UIApplication.shared.statusBarStyle = .lightContent
            
            navigationController?.navigationBar.tintColor = UIColor.orange
        }
        
        for i in 0..<labelArray.count {
            labelArray[i].textColor = isLightTheme ? UIColor.black : UIColor.white
            pickerViewArray[i].reloadComponent(0)
            
        }
        
        navigationController?.navigationBar.barTintColor = isLightTheme ? UIColor.white : UIColor.black
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: isLightTheme ? UIColor.black : UIColor.white]
    }
}

extension SettingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == decimalPlacesPickerView {
            return 20
        }
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == decimalPlacesPickerView) {
            return String(row + 1)
        }
        return themes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == decimalPlacesPickerView {
            decimalPlaces = row + 1
            return
        }
        
        isLightTheme = row == 0 ? true : false
        loadTheme()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let textColor = isLightTheme ? UIColor.black : UIColor.white
        if pickerView == decimalPlacesPickerView {
            let attributedString = NSAttributedString(string: "\(row + 1)", attributes: [NSAttributedStringKey.foregroundColor: textColor])
            return attributedString
        }
        
        let attributedString = NSAttributedString(string: themes[row], attributes: [NSAttributedStringKey.foregroundColor: textColor])
        return attributedString
    }
}

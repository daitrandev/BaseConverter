//
//  SettingViewController.swift
//  BaseConverter
//
//  Created by Dai Tran on 4/23/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit

protocol SettingDelegate: class {
    func loadThemeAndUpdateFormat()
}

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
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    var decimalPlaces: Int = UserDefaults.standard.integer(forKey: decimalPlaceKey)
    var isLightTheme: Bool = UserDefaults.standard.bool(forKey: isLightThemeKey)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isLightTheme ? .default : .lightContent
    }
    
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

        view.addSubview(decimalPlacesPickerView)
        view.addSubview(decimalPlacesLabel)
        view.addSubview(themePickerView)
        view.addSubview(themeLabel)
        
        decimalPlacesPickerView.constraintTo(top: view.layoutMarginsGuide.topAnchor, bottom: nil, left: view.centerXAnchor, right: nil, topConstant: 8, bottomConstant: 0, leftConstant: 8, rightConstant: 0)
        decimalPlacesPickerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
        decimalPlacesPickerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        
        decimalPlacesLabel.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -8).isActive = true
        decimalPlacesLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        decimalPlacesLabel.centerYAnchor.constraint(equalTo: decimalPlacesPickerView.centerYAnchor).isActive = true
        
        themePickerView.constraintTo(top: decimalPlacesPickerView.bottomAnchor, bottom: nil, left: decimalPlacesPickerView.leftAnchor, right: decimalPlacesPickerView.rightAnchor, topConstant: 8, bottomConstant: 0, leftConstant: 0, rightConstant: 0)
        themePickerView.heightAnchor.constraint(equalTo: decimalPlacesPickerView.heightAnchor).isActive = true
        
        themeLabel.rightAnchor.constraint(equalTo: decimalPlacesLabel.rightAnchor).isActive = true
        themeLabel.leftAnchor.constraint(equalTo: decimalPlacesLabel.leftAnchor).isActive = true
        themeLabel.centerYAnchor.constraint(equalTo: themePickerView.centerYAnchor).isActive = true

        let selectedRowTheme = isLightTheme ? 0 : 1
        themePickerView.selectRow(selectedRowTheme, inComponent: 0, animated: false)
        decimalPlacesPickerView.selectRow(decimalPlaces - 1, inComponent: 0, animated: false)
        
        decimalPlacesLabel.text = NSLocalizedString("DecimalPlaces", comment: "")
        themeLabel.text = NSLocalizedString("Theme", comment: "")
        navigationItem.title = NSLocalizedString("Setting", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: .done, target: self, action: #selector(didTapClose))
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    func loadTheme() {
        
        let labelArray: [UILabel] = [decimalPlacesLabel, themeLabel]
        let pickerViewArray: [UIPickerView] = [decimalPlacesPickerView, themePickerView]
        
        view.backgroundColor = isLightTheme ? UIColor.white : UIColor.black
        
        navigationController?.navigationBar.tintColor = isLightTheme ? UIColor.deepBlue : UIColor.orange
        
        for i in 0..<labelArray.count {
            labelArray[i].textColor = isLightTheme ? UIColor.black : UIColor.white
            pickerViewArray[i].reloadComponent(0)
            
        }
        
        navigationController?.navigationBar.barTintColor = isLightTheme ? UIColor.white : UIColor.black
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: isLightTheme ? UIColor.black : UIColor.white]
        
        setNeedsStatusBarAppearanceUpdate()
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
            let attributedString = NSAttributedString(string: "\(row + 1)", attributes: [NSAttributedString.Key.foregroundColor: textColor])
            return attributedString
        }
        
        let attributedString = NSAttributedString(string: themes[row], attributes: [NSAttributedString.Key.foregroundColor: textColor])
        return attributedString
    }
}

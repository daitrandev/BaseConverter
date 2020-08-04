//
//  AllBasesViewModel.swift
//  BaseConverter
//
//  Created by DaiTran on 8/1/20.
//  Copyright © 2020 Dai Tran. All rights reserved.
//

protocol AllBasesViewModelDelegate: class {
    func reloadTableView()
}

protocol AllBasesViewModelType: class {
    var cellLayoutItems: [AllBasesViewModel.CellLayoutItem] { get }
    var isPurchased: Bool { get }
    var delegate: AllBasesViewModelDelegate? { get set }
    func didChange(value: String, from base: Int)
    func clear(exclusive baseValue: Int?)
}

class AllBasesViewModel: AllBasesViewModelType {
    struct CellLayoutItem {
        let baseValue: Int
        var content: String
        let allowingCharacters: String
    }
    
    private let minimumBase: Int = 2
    private let maximumBase: Int = 36
    private let numAndAlphabet: String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    var isPurchased: Bool {
        GlobalKeychain.getBool(for: KeychainKey.isPurchased) ?? false
    }
    
    var cellLayoutItems: [AllBasesViewModel.CellLayoutItem] {
        didSet {
            delegate?.reloadTableView()
        }
    }
    
    weak var delegate: AllBasesViewModelDelegate?
    
    init() {
        var cellLayoutItems: [AllBasesViewModel.CellLayoutItem] = []
        for baseValue in minimumBase...maximumBase {
            let allowingCharacters = String(numAndAlphabet.prefix(baseValue))
            cellLayoutItems.append(
                .init(baseValue: baseValue, content: "", allowingCharacters: allowingCharacters)
            )
        }
        self.cellLayoutItems = cellLayoutItems
    }
    
    func clear(exclusive baseValue: Int?) {
        var cellLayoutItems = self.cellLayoutItems
        for index in 0..<cellLayoutItems.count {
            if cellLayoutItems[index].baseValue == baseValue {
                continue
            }
            cellLayoutItems[index].content = ""
        }
        self.cellLayoutItems = cellLayoutItems
    }
    
    func didChange(value: String, from baseValue: Int) {
        let floatingPointCharacter = FloatingPointCharacter.init(string: value)
        
        var cellLayoutItems = self.cellLayoutItems
        for index in 0..<cellLayoutItems.count {
            if baseValue == cellLayoutItems[index].baseValue {
                cellLayoutItems[index].content = value
                continue
            }
            
            let content: String
            if floatingPointCharacter == nil {
                guard let base10 = Int(value, radix: baseValue) else {
                    cellLayoutItems[index].content = ""
                    continue
                }
                content = String(base10, radix: cellLayoutItems[index].baseValue).uppercased()
            } else {
                guard let base10FloatingPoint = BaseConverter.convertFloatingNumToBase10(floating: value, from: baseValue) else {
                    cellLayoutItems[index].content = ""
                    continue
                }
                content = BaseConverter.convertFromBase10FloatingPoint(floating: base10FloatingPoint, to: cellLayoutItems[index].baseValue) ?? ""
            }
            
            cellLayoutItems[index].content = content
        }
        
        self.cellLayoutItems = cellLayoutItems
    }
}

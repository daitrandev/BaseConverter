//
//  CommonBasesViewModel.swift
//  BaseConverter
//
//  Created by DaiTran on 8/1/20.
//  Copyright © 2020 Dai Tran. All rights reserved.
//

protocol CommonBasesViewModelDelegate: class {
    func reloadTableView()
}

protocol CommonBasesViewModelType: class {
    var cellLayoutItems: [CommonBasesViewModel.CellLayoutItem] { get }
    var delegate: CommonBasesViewModelDelegate? { get set }
    func clear(exclusive baseValue: Int?)
    func didChange(value: String, from baseValue: Int)
}

class CommonBasesViewModel: CommonBasesViewModelType {
    struct CellLayoutItem {
        let base: CommonBase
        var content: String
    }
    
    var cellLayoutItems: [CellLayoutItem] {
        didSet {
            delegate?.reloadTableView()
        }
    }
    
    weak var delegate: CommonBasesViewModelDelegate?
    
    init() {
        cellLayoutItems = [
            CellLayoutItem(
                base: .binaryCode,
                content: ""
            ),
            CellLayoutItem(
                base: .octalCode,
                content: ""
            ),
            CellLayoutItem(
                base: .decimalCode,
                content: ""
            ),
            CellLayoutItem(
                base: .hexaCode,
                content: ""
            )
        ]
    }
    
    func clear(exclusive baseValue: Int?) {
        var cellLayoutItems = self.cellLayoutItems
        for index in 0..<cellLayoutItems.count {
            if cellLayoutItems[index].base.rawValue == baseValue {
                continue
            }
            cellLayoutItems[index].content = ""
        }
        self.cellLayoutItems = cellLayoutItems
    }
    
    func didChange(value: String, from baseValue: Int) {
        if value.last == "." || value.last == "," {
            clear(exclusive: baseValue)
            return
        }
        
        let floatingPointCharacter = FloatingPointCharacter.init(string: value)
        
        var cellLayoutItems = self.cellLayoutItems
        for index in 0..<cellLayoutItems.count {
            if baseValue == cellLayoutItems[index].base.rawValue {
                cellLayoutItems[index].content = value
                continue
            }
            
            let content: String
            if floatingPointCharacter == nil {
                guard let base10 = Int(value, radix: baseValue) else {
                    cellLayoutItems[index].content = ""
                    continue
                }
                content = String(base10, radix: cellLayoutItems[index].base.rawValue).uppercased()
            } else {
                guard let base10FloatingPoint = BaseConverter.convertFloatingNumToBase10(floating: value, from: baseValue) else {
                    cellLayoutItems[index].content = ""
                    continue
                }
                content = base10FloatingPoint
            }
            
            cellLayoutItems[index].content = content
        }
        
        self.cellLayoutItems = cellLayoutItems
    }
}

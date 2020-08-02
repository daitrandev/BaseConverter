//
//  AllBasesTableViewController.swift
//  BaseConverter
//
//  Created by Dai Tran on 4/20/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit

class AllBasesTableViewController: CommonBasesTableViewController {
    private let viewModel: AllBasesViewModelType
    
    let numAndAlphabet: String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    override init() {
        viewModel = AllBasesViewModel()
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        title = "All Bases"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellLayoutItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommonBasesTableViewCell
        cell.configure(with: viewModel.cellLayoutItems[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    override func reloadTableView() {
        for cell in tableView.visibleCells {
            guard let indexPath = tableView.indexPath(for: cell) else { continue }
            let cell = cell as? CommonBasesTableViewCell
            cell?.configure(with: viewModel.cellLayoutItems[indexPath.row])
        }
    }
    
    override func didChange(value: String, from baseValue: Int) {
        viewModel.didChange(value: value, from: baseValue)
    }
    
    override func didTapClear() {
        viewModel.clear(exclusive: nil)
    }
}

extension AllBasesTableViewController: AllBasesViewModelDelegate { }

//
//  AllBasesTableViewController.swift
//  BaseConverter
//
//  Created by Dai Tran on 4/20/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit

class AllBasesTableViewController: CommonBasesTableViewController {
    
    let numAndAlphabet: String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        bases.removeAll()
        let baseString = NSLocalizedString("Base", comment: "")
        for i in 2...36 {
            let base = Base(baseLabelText: baseString + " \(i)", baseTextFieldTag: i - 2, baseTextFieldText: nil)
            bases.append(base)
        }
        
    }
    
    override func setupTableView() {
        super.setupTableView()
        tableView.register(AllBasesTableViewCell.self, forCellReuseIdentifier: cellId)
        self.title = NSLocalizedString("AllBases", comment: "")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AllBasesTableViewCell
        cell.base = bases[indexPath.row]
        cell.tag = indexPath.row
        cell.updateLabelColor()
        cell.delegate = self
        return cell
    }
}

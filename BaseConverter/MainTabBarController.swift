//
//  MainTabBarController.swift
//  BaseConverter
//
//  Created by Dai Tran on 4/20/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let commonBasesTableViewController = CommonBasesTableViewController()
        let commonBasesTableViewControllerNav = UINavigationController(rootViewController: commonBasesTableViewController)
        commonBasesTableViewControllerNav.tabBarItem.title = NSLocalizedString("CommonBases", comment: "")
        commonBasesTableViewControllerNav.tabBarItem.image = #imageLiteral(resourceName: "common-list")
        
        let allBasesTableViewController = AllBasesTableViewController()
        let allBasesTableViewControllerNav = UINavigationController(rootViewController: allBasesTableViewController)
        allBasesTableViewControllerNav.tabBarItem.title = NSLocalizedString("AllBases", comment: "")
        allBasesTableViewControllerNav.tabBarItem.image = #imageLiteral(resourceName: "all-list")
        
        viewControllers = [commonBasesTableViewControllerNav, allBasesTableViewControllerNav]
    }
}

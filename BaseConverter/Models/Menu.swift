//
//  Menu.swift
//  BaseConverter
//
//  Created by Macbook on 2/23/19.
//  Copyright © 2019 Dai Tran. All rights reserved.
//

enum MenuSection: String {
    case setting = "setting"
    case feedback = "feedback"
    case rate = "rate"
    case share = "share"
}

struct Menu {
    let title: String
    let menuSection: MenuSection
}

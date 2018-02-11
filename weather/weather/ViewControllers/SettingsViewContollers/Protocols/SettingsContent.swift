//
//  SettingsContent.swift
//  Weather
//
//  Created by SteveLin on 2018/2/11.
//  Copyright © 2018年 alin. All rights reserved.
//

import UIKit


protocol SettingsRepresentable {
    var labelText: String { get }
    var accessory: UITableViewCellAccessoryType { get }
}

//
//  SettingsDateViewModel.swift
//  Weather
//
//  Created by SteveLin on 2018/2/11.
//  Copyright © 2018年 alin. All rights reserved.
//

import UIKit



struct SettingsDateViewModel: SettingsRepresentable {
    
    let dateMode: DateMode
    
    var labelText: String {
        return dateMode == .text ? "Fri, 01 December" : "F, 12/01"
    }
    var accessory: UITableViewCellAccessoryType {
        if UserDefaults.dateMode() == dateMode {
            return .checkmark
        }
        else {
            return .none
        }
    }
}

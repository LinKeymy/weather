//
//  SettingsTableViewCell.swift
//  Weather
//
//  Created by SteveLin on 2018/2/11.
//  Copyright © 2018年 alin. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    func configure(with vm: SettingsRepresentable) {
        contentLabel.text = vm.labelText
        accessoryType = vm.accessory
    }
    
    static let reuseIdentifier = "SettingsTableViewCell"

    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

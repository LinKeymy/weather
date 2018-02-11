//
//  TodoItemCell.swift
//  Weather
//
//  Created by SteveLin on 2018/2/11.
//  Copyright © 2018年 alin. All rights reserved.
//

import UIKit

class TodoItemCell: UITableViewCell {
    
    @IBOutlet weak var checkMarkLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

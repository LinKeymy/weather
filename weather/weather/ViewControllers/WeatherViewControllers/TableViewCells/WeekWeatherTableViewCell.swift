//
//  WeekWeatherTableViewCell.swift
//  Weather
//
//  Created by SteveLin on 2018/2/10.
//  Copyright © 2018年 alin. All rights reserved.
//

import UIKit

class WeekWeatherTableViewCell: UITableViewCell {
    static let reuseIdentifier = "WeekWeatherCell"
    
    @IBOutlet weak var week: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var humidity: UILabel!
    
    func configure(with vm: WeekWeatherDayRepresentable) {
        week.text = vm.week
        date.text = vm.date
        humidity.text = vm.humidity
        temperature.text = vm.temperature
        weatherIcon.image = vm.weatherIcon
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

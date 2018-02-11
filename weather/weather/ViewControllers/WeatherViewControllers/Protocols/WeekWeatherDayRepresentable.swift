//
//  WeekWeatherDayRepresentable.swift
//  Weather
//
//  Created by SteveLin on 2018/2/11.
//  Copyright © 2018年 alin. All rights reserved.
//

import UIKit

protocol WeekWeatherDayRepresentable {
    var week: String { get }
    var date: String { get }
    var temperature: String { get }
    var weatherIcon: UIImage? { get }
    var humidity: String { get }
}

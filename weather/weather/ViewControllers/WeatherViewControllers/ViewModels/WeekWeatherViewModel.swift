//
//  WeekWeatherViewModel.swift
//  Weather
//
//  Created by SteveLin on 2018/2/10.
//  Copyright © 2018年 alin. All rights reserved.
//

import UIKit

struct WeekWeatherViewModel {
    let weatherData: [ForecastData]
    func viewModel(for index: Int) -> WeekWeatherDayViewModel {
            return WeekWeatherDayViewModel(
                weatherData: weatherData[index])
    }
}


//
//  CurrentWeatherViewModel.swift
//  Weather
//
//  Created by SteveLin on 2018/2/10.
//  Copyright © 2018年 alin. All rights reserved.
//

import UIKit


struct CurrentWeatherViewModel {

    var location: Location! {
        didSet {
            if location != nil {
                self.isLocationReady = true
            }
            else {
                self.isLocationReady = false
            }
        }
    }
    
    var weather: WeatherInfo! {
        didSet {
            if weather != nil {
                self.isWeatherReady = true
            }
            else {
                self.isWeatherReady = false
            }
        }
    }
    
    var isLocationReady = false
    var isWeatherReady = false
    
    var isUpdateReady: Bool {
        return isLocationReady && isWeatherReady
    }
    
}

// get and data
extension CurrentWeatherViewModel {
    var weatherIcon: UIImage {
        return UIImage.weatherIcon(name: weather.currently.icon)!
    }
    
    var city: String {
        return location.name
    }
    
    var temperature: String {
        return String(
            format: "%.1f °C",
            weather.currently.temperature.toCelcius())
    }
    
    var humidity: String {
        return String(
            format: "%.1f %%",
            weather.currently.humidity * 100)
    }
    
    var summary: String {
        return weather.currently.summary
    }
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMMM"
        
        return formatter.string(from: weather.currently.time)
    }
}

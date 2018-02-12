//
//  WeatherInfo.swift
//  Weather
//
//  Created by SteveLin on 2018/2/9.
//  Copyright © 2018年 alin. All rights reserved.
//

import Foundation

struct WeatherInfo: Codable {
    
    let latitude: Double
    let longitude: Double
    let currently: CurrentWeather
    let daily: WeekWeatherData
    
    struct CurrentWeather: Codable {
        let time: Date
        let summary: String
        let icon: String
        let temperature: Double
        let humidity: Double
    }
    
    struct WeekWeatherData: Codable {
        let data: [ForecastData]
    }

}

extension WeatherInfo: Equatable {
    
        public static func ==(lhs: WeatherInfo,
                              rhs: WeatherInfo) -> Bool {
            return lhs.latitude == rhs.latitude &&
                lhs.longitude == rhs.longitude &&
                lhs.currently == rhs.currently
        }
}

extension WeatherInfo.CurrentWeather: Equatable {
    public static func ==(lhs: WeatherInfo.CurrentWeather,
                          rhs: WeatherInfo.CurrentWeather) -> Bool {
        return lhs.time == rhs.time &&
            lhs.summary == rhs.summary &&
            lhs.icon == rhs.icon &&
            lhs.temperature == rhs.temperature &&
            lhs.humidity == rhs.humidity
    }
}

extension WeatherInfo.WeekWeatherData: Equatable {
    public static func ==(lhs: WeatherInfo.WeekWeatherData,
                          rhs: WeatherInfo.WeekWeatherData) -> Bool {
        return lhs.data == rhs.data
    }
}








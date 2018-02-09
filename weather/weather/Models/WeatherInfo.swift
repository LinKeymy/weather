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
    
    struct CurrentWeather: Codable {
        let time: Date
        let summary: String
        let icon: String
        let temperature: Double
        let humidity: Double
    }
    

}

extension WeatherInfo: Equatable {
    /*
     /Users/stevelin/Documents/GitHub/weather/Weather/Weather/Models/WeatherInfo.swift:28:32: 'Self' is only available in a protocol or as the result of a method in a class; did you mean 'WeatherInfo'?
     */
//    public static func ==(lhs: Self, rhs: Self) -> Bool {
//        return lhs.latitude == rhs.latitude &&
//            lhs.longitude == rhs.longitude &&
//            lhs.currently == rhs.currently
//    }
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







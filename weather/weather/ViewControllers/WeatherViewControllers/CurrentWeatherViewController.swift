//
//  CurrentWeatherViewController.swift
//  Weather
//
//  Created by SteveLin on 2018/2/10.
//  Copyright © 2018年 alin. All rights reserved.
//

import UIKit


protocol CurrentWeatherViewControllerDelegate: class {
    func locationButtonPressed(controller: CurrentWeatherViewController)
    func settingsButtonPressed(controller: CurrentWeatherViewController)
}


class CurrentWeatherViewController: WeatherViewController {
    @IBOutlet weak var tapNavBar: UINavigationBar!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationItem: UINavigationItem!
    
    var delegate: CurrentWeatherViewControllerDelegate?

    var now: WeatherInfo? {
        didSet {
            DispatchQueue.main.async { self.updateView() }
        }
    }
    var location: Location? {
        didSet {
            DispatchQueue.main.async { self.updateView() }
        }
    }
    
    
    
    func updateView() {
        activityIndicatorView.stopAnimating()
        
        if let now = now, let location = location {
            updateWeatherContainer(with: now, at: location)
        }
        else {
            loadingFailedLabel.isHidden = false
            loadingFailedLabel.text =
            "Cannot load fetch weather/location data from the network."
        }
    }
    
    func updateWeatherContainer(
        with data: WeatherInfo, at location: Location) {
        weatherContainerView.isHidden = false
        
        // 1. Set location
        locationItem.title = location.name
        
        // 2. Format and set temperature
        temperatureLabel.text = String(
            format: "%.1f °C",
            data.currently.temperature.toCelcius())
        
        // 3. Set weather icon
        weatherIcon.image = weatherIcon(
            of: data.currently.icon)
        
        // 4. Format and set humidity
        humidityLabel.text = String(
            format: "%.1f",
            data.currently.humidity)
        
        // 5. Set weather summary
        summaryLabel.text = data.currently.summary
        
        // 6. Format and set datetime
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMMM"
        dateLabel.text = formatter.string(
            from: data.currently.time)
    }
    
    
    @IBAction func locationButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.locationButtonPressed(controller: self)
    }
    
}


extension CurrentWeatherViewController {

    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        delegate?.settingsButtonPressed(controller: self)
    }
}

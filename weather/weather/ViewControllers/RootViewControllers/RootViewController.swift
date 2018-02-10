//
//  ViewController.swift
//  Weather
//
//  Created by SteveLin on 2018/2/9.
//  Copyright © 2018年 alin. All rights reserved.
//

import UIKit
import CoreLocation

class RootViewController: UIViewController {
    
    private let segueCurrentWeather = "SegueCurrentWeather"
    private let segueWeekWeather = "SegueWeekWeather"
    var currentWeatherViewController: CurrentWeatherViewController!
    var weekWeatherViewController: WeekWeatherViewController!
    
    private var currentLocation: CLLocation? {
        didSet {
            // Fetch the city name
            fetchCity()
            // Fetch the weather data
            fetchWeather()
        }
    }
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.distanceFilter = 1000
        manager.desiredAccuracy = 1000
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActiveNotification()
    }
    
    @objc func applicationDidBecomeActive(
        notification: Notification) {
        requestLocation()
    }
    
    private func setupActiveNotification() {
        NotificationCenter.default.addObserver(
            self, selector:
            #selector(applicationDidBecomeActive(notification:)),
            name: Notification.Name.UIApplicationDidBecomeActive,
            object: nil)
    }
    
    // get location wheather authorizationed or not
    private func requestLocation() {
       locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestLocation()  // requestLocation
        }
        else {
            locationManager.requestWhenInUseAuthorization() // requestAuthrization
        }
    }
    
}


// segue
extension RootViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier
            else { return }
        switch identifier  {
        case segueCurrentWeather:
            guard let destination =
                segue.destination as? CurrentWeatherViewController
                else  { fatalError("Invalid destination view controller.") }
            destination.delegate = self
            destination.viewModel = CurrentWeatherViewModel()
            currentWeatherViewController = destination
        case segueWeekWeather:
            guard let destination =
                segue.destination as? WeekWeatherViewController
                else { fatalError("Invalid destination view controller.") }
            self.weekWeatherViewController = destination
        default:
            break
        }
    }
}


extension RootViewController: CurrentWeatherViewControllerDelegate {
    
    func locationButtonPressed(controller: CurrentWeatherViewController) {
        
    }
    
    func settingsButtonPressed(controller: CurrentWeatherViewController) {
        
    }
}


// fetch data
extension RootViewController {
    
    private func fetchCity() {
        guard let currentLocation = currentLocation
            else { return }
        CLGeocoder().reverseGeocodeLocation(
        currentLocation, 
        preferredLocale:nil) { (placemarks, error) in
            if let error = error {
                dump(error)
            }
            else if let city = placemarks?.first?.locality {
                self.currentWeatherViewController.viewModel?.location =
                Location(name: city,
                         latitude: currentLocation.coordinate.latitude,
                         longitude: currentLocation.coordinate.longitude)
            }
        }
    }
    
    private func fetchWeather() {
        guard let currentLocation = currentLocation
            else { return }
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        WeatherInfoManager.shared.weatherInformation(
            atLatitude: lat,
            longitude: lon) { (weather, error) in
                if let error = error {
                    dump(error)
                }
                else if let weather = weather {
                    self.currentWeatherViewController.viewModel?.weather = weather
                    self.weekWeatherViewController.viewModel =
                        WeekWeatherViewModel(weatherData: weather.daily.data)
                
                }
        }
    }
}

extension RootViewController: CLLocationManagerDelegate {
    // get location
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            manager.delegate = nil
            manager.stopUpdatingLocation()
        }
    }
    
    // get authorization status
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    // dump fail error
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error) {
        dump(error)
    }
}


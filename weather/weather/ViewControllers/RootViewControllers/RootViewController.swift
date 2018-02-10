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
                // TODO: Notify CurrentWeatherViewController
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
                if error = error {
                    dump(error)
                }
                else if let weather = weather {
                   // TODO: Notify CurrentWeatherViewController
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


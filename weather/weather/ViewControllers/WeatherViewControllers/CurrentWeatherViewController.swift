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
    
    private let segueSettings = "SegueSettings"
    
    @IBOutlet weak var topNavBar: UINavigationBar!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationItem: UINavigationItem!
    
    var delegate: CurrentWeatherViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setupView() {
        
    }
    
    @IBAction func locationButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.locationButtonPressed(controller: self)
        print("locationButtonPressed")
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.locationButtonPressed(controller: self)
        print("settingsButtonPressed")
    }

    var viewModel: CurrentWeatherViewModel? {
        didSet {
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    
    
    func updateView() {
        activityIndicatorView.stopAnimating()
        
        
        if let vm = viewModel, vm.isUpdateReady {
            updateWeatherContainer(with: vm)
        }
        
        else {
            loadingFailedLabel.isHidden = false
            loadingFailedLabel.text =
            "Cannot load fetch weather/location data from the network."
        }
    }
    
    func updateWeatherContainer(with vm: CurrentWeatherViewModel) {
        weatherContainerView.isHidden = false
        locationItem.title = vm.city
        weatherIcon.image = vm.weatherIcon
        humidityLabel.text = vm.humidity
        summaryLabel.text = vm.summary
        dateLabel.text = vm.date
    }
}


extension CurrentWeatherViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier
            else { return }
        print(identifier)
        switch identifier {
        case segueSettings:
            guard let destination = segue.destination as? UINavigationController,
                let topController = destination.topViewController as? SettingsViewController
                else { fatalError("Invalid destination view controller") }
            guard let root = self.delegate as? RootViewController
                else { fatalError("Unexpected delegate") }
            topController.delegate = root
        default:
            break
        }
    }
    
    @IBAction func unwindToRootViewController(
        segue: UIStoryboardSegue) {
        print(segue)
    }
    
}


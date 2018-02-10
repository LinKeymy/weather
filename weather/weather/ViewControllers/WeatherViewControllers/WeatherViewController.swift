//
//  WeatherViewController.swift
//  Weather
//
//  Created by SteveLin on 2018/2/10.
//  Copyright © 2018年 alin. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    
    @IBOutlet weak var weatherContainerView: UIView!
    @IBOutlet weak var loadingFailedLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        weatherContainerView.isHidden = true
        loadingFailedLabel.isHidden = true
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidesWhenStopped = true
    }
    
    func weatherIcon(of name: String) -> UIImage? {
        var localName: String!
        switch name {
        case "clear-day":
            localName = "clear-day"
        case "clear-night":
            localName = "clear-night"
        case "rain":
            localName = "rain"
        case "snow":
            localName = "snow"
        case "sleet":
            localName = "sleet"
        case "wind":
            localName = "wind"
        case "cloudy":
            localName = "cloudy"
        case "partly-cloudy-day":
            localName = "partly-cloudy-day"
        case "partly-cloudy-night":
            localName = "partly-cloudy-night"
        default:
            localName = "clear-day"
        }
        return UIImage(named:localName)
    }
}

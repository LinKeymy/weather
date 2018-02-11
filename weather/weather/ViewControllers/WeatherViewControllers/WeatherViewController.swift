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
    

}



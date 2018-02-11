//
//  WeekWeatherViewController.swift
//  Weather
//
//  Created by SteveLin on 2018/2/10.
//  Copyright © 2018年 alin. All rights reserved.
//

import UIKit


class WeekWeatherViewController: WeatherViewController {
    
    @IBOutlet weak var weekWeatherTableView: UITableView!
    
    var viewModel: WeekWeatherViewModel? {
        didSet {
            DispatchQueue.main.async { self.updateView() }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateView() {
        activityIndicatorView.stopAnimating()
        
        if let _ = viewModel {
            updateWeatherDataContainer()
            
        } else {
            loadingFailedLabel.isHidden = false
            loadingFailedLabel.text = "Load Location/Weather failed!"
        }
    }
    
    func updateWeatherDataContainer() {
        weatherContainerView.isHidden = false
        weekWeatherTableView.reloadData()
    }
}


extension WeekWeatherViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.weatherData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: WeekWeatherTableViewCell.reuseIdentifier,
            for: indexPath) as? WeekWeatherTableViewCell
        else { fatalError("Unexpected TableVeiwCell") }

        if let vm = viewModel?.viewModel(for: indexPath.row) {
            cell.configure(with: vm)
        }
        return cell
    }
}

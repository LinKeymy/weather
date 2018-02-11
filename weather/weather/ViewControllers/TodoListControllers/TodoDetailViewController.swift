//
//  TodoDetailViewController.swift
//  Weather
//
//  Created by SteveLin on 2018/2/11.
//  Copyright © 2018年 alin. All rights reserved.
//

import UIKit

class TodoDetailViewController: UITableViewController {

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

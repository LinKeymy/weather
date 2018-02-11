//
//  TodoListViewController.swift
//  Weather
//
//  Created by SteveLin on 2018/2/11.
//  Copyright © 2018年 alin. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    @IBAction func backButtonPressed(_ sender: UIStoryboardSegue) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

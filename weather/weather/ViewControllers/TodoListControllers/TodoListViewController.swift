//
//  TodoListViewController.swift
//  Weather
//
//  Created by SteveLin on 2018/2/11.
//  Copyright © 2018年 alin. All rights reserved.
//

import UIKit


enum SaveTodoError: Error {
    case cannotSaveToLocalFile
    case iCloudIsNotEnabled
    case cannotReadLocalFile
    case cannotCreateFileOnCloud
}

class TodoListViewController: UIViewController {
    
    private let segueEditTodoItem = "SegueEditTodoItem"
    private let segueAddTodoItem = "SegueAddTodoItem"
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var syncCloudButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            fatalError("identifier is nil")
        }
        guard let destination = segue.destination as? UINavigationController,
        let topVc = destination.topViewController as? TodoDetailViewController else {
            fatalError("Unexpected viewController")
        }
        switch identifier {
        case segueAddTodoItem:
            topVc.title = "AddTodo"
        case segueEditTodoItem:
            topVc.title = "EditTodo"
        default:
            break
        }
    }
    
    @IBAction func saveTodoListToFile(_ sender: UIButton) {
        
        
    }
    

    @IBAction func syncTodoListToCloud(_ sender: UIButton) {
        
        
    }
    
    @IBAction func clearTodoList(_ sender: UIButton) {
        
    }
}

// datasource
extension TodoListViewController {
    
    
}

// delegate
extension TodoListViewController {
    
}


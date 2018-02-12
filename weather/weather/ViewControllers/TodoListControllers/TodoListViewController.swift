//
//  TodoListViewController.swift
//  Weather
//
//  Created by SteveLin on 2018/2/11.
//  Copyright © 2018年 alin. All rights reserved.
//

import UIKit
import RxSwift

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
    @IBOutlet weak var addtodoButton: UIBarButtonItem!
    
    var bag = DisposeBag()
    
    lazy var todosViewModel: TodoItemsViewModel = {
        return TodoItemsViewModel()
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        todosViewModel.loadTodoItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todosViewModel.todosObseverble.subscribe(
            onNext: { self.updateUI(todos: $0) })
            .disposed(by: bag)
    }
    
    private func updateUI(todos:[TodoItem]) {
        clearButton.isEnabled = !todos.isEmpty
        addtodoButton.isEnabled = todos.filter { !$0.isFinished }.count < 5
        title = todos.isEmpty ? "Todo" : "\(todos.count) ToDos"
        self.tableView.reloadData()
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: {
            self.saveTodoListToFile(UIButton())
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            fatalError("identifier is nil")
        }
        guard let destination = segue.destination as? UINavigationController,
        let todoDetailVc = destination.topViewController as? TodoDetailViewController else {
            fatalError("Unexpected viewController")
        }
        switch identifier {
        case segueAddTodoItem:
            todoDetailVc.title = "AddTodo"
            _ = todoDetailVc.todo.subscribe( // 订阅新添加todo的事件
                onNext: { [weak self] newTodo in
                    self?.todosViewModel.todoItems.value.append(newTodo)
                })
        case segueEditTodoItem:
            todoDetailVc.title = "EditTodo"
            if let indexPath = tableView.indexPath(for: sender as! TodoItemCell) {
                todoDetailVc.todoItem = todosViewModel.todoItems.value[indexPath.row]
                _ = todoDetailVc.todo.subscribe( // 订阅编辑更新的消息
                    onNext: { [weak self] newTodo in
                        self?.todosViewModel.todoItems.value[indexPath.row] = newTodo
                })
            }
        default:
            break
        }
    }
    
    @IBAction func saveTodoListToFile(_ sender: UIButton) {

        _ = todosViewModel.saveTodoItems().subscribe(
            onError: {  [weak self] error in
                self?.flash(title: "Success",
                            message: error.localizedDescription) },
            onCompleted:{ [weak self] in
                self?.flash(title: "Success",
                            message: "All Todos are saved on your phone.")},
            onDisposed: { print("SaveOb disposed")  }
            )
    }

    @IBAction func syncTodoListToCloud(_ sender: UIButton) {

        _ = todosViewModel.syncTodoToCloud().subscribe(
            onNext: {
                self.flash(title: "Success",
                           message: "All todos are synced to: \($0)")
        },
            onError: {
                self.flash(title: "Failed",
                           message: "Sync failed due to: \($0.localizedDescription)")
        },
            onDisposed: { print("SyncOb disposed")}
            )
    }
    
    @IBAction func clearTodoList(_ sender: UIButton) {
        print("clearTodoList")
        todosViewModel.todoItems.value.removeAll()
    }
}

// datasource
extension TodoListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return todosViewModel.numberOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todosViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: TodoItemCell.identifier, for: indexPath) as? TodoItemCell else {
            fatalError("Uexpected cell")
        }
        update(cell: cell, for: indexPath.row)
        return cell
    }
    
    private func update(cell: TodoItemCell , for row: Int) {
        let todoItem = todosViewModel.todoItem(for: row)
        cell.checkMarkLabel.text = todoItem.isFinished ? "✓" : ""
        cell.taskNameLabel.text = todoItem.name
    }
}

// delegate
extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let todo = todosViewModel.todoItems.value[indexPath.row]
            todo.toggleFinished()
            
            todosViewModel.todoItems.value[indexPath.row] = todo
            update(cell: cell as! TodoItemCell, for: indexPath.row)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        todosViewModel.todoItems.value.remove(at: indexPath.row)
    }
    
}


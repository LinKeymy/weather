//
//  TodoItemsViewModel.swift
//  Weather
//
//  Created by SteveLin on 2018/2/11.
//  Copyright © 2018年 alin. All rights reserved.
//

import UIKit
import RxSwift


class TodoItemsViewModel {
    
    var todoItems = Variable<[TodoItem]>([])
    var todosObseverble: Observable<[TodoItem]>  {
        return todoItems.asObservable()
    }
    
    
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfRows: Int {
        return todoItems.value.count
    }
    
    func todoItem(for row: Int) -> TodoItem {
        return todoItems.value[row]
    }
    
    func ubiquityURL(_ filename: String) -> URL? {
        let ubiquityURL =
            FileManager.default.url(forUbiquityContainerIdentifier: nil)
        
        if ubiquityURL != nil {
            return ubiquityURL!.appendingPathComponent(filename)
        }
        return nil
    }
    
    func documentsDirectory() -> URL {
        let path = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask)
        
        return path[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("TodoList.plist")
    }
    
    func syncTodoToCloud() -> Observable<URL>  {
        
        return Observable.create({ observer in
            guard let cloudUrl = self.ubiquityURL("Documents/TodoList.plist") else {
                observer.onError(SaveTodoError.iCloudIsNotEnabled)
                return Disposables.create()
            }
            
            guard let localData = NSData(contentsOf: self.dataFilePath()) else {
                observer.onError(SaveTodoError.cannotReadLocalFile)
                return Disposables.create()
            }
            
            let plist = PlistDocument(fileURL: cloudUrl, data: localData)
            
            plist.save(to: cloudUrl, for: .forOverwriting, completionHandler: {
                (success: Bool) -> Void in
                
                if success {
                    observer.onNext(cloudUrl)
                    observer.onCompleted()
                } else {
                    observer.onError(SaveTodoError.cannotCreateFileOnCloud)
                }
            })
            
            return Disposables.create()
        })
        
        
    }
    
    func saveTodoItems() -> Observable<Void> {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        archiver.encode(todoItems.value, forKey: "TodoItems")
        archiver.finishEncoding()
        
        return Observable.create({ observer in
            
            let result = data.write(
                to: self.dataFilePath(), atomically: true)
            
            if !result {
                observer.onError(SaveTodoError.cannotSaveToLocalFile)
            }
            else {
                observer.onCompleted()
            }
            
            return Disposables.create()
        })
    }
    
    func loadTodoItems() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            todoItems.value = unarchiver.decodeObject(forKey: "TodoItems") as! [TodoItem]
            unarchiver.finishDecoding()
        }
    }
}



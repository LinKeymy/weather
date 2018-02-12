//
//  TodoDetailViewController.swift
//  Weather
//
//  Created by SteveLin on 2018/2/11.
//  Copyright © 2018年 alin. All rights reserved.
//

import UIKit
import RxSwift

class TodoDetailViewController: UITableViewController {
    
    @IBOutlet weak var isFinished: UISwitch!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var collageButton: UIButton!
    @IBOutlet weak var taskName: UITextField!
    
    fileprivate let images = Variable<[UIImage]>([])
    fileprivate var todoCollage: UIImage?
    fileprivate let todoSubject = PublishSubject<TodoItem>()
    
    var todo: Observable<TodoItem> {
        return todoSubject.asObserver()
    }
    
    var bag = DisposeBag()
    var todoItem: TodoItem!

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        todoItem.name = taskName.text ?? ""
        todoItem.isFinished = isFinished.isOn
        todoItem.pictureMemoFilename = savePictureMemos()
        
        // 向订阅者发送next和complted事件
        todoSubject.onNext(todoItem)
        todoSubject.onCompleted()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    fileprivate func savePictureMemos() -> String {
        if let todoCollage = todoCollage, //  new phone return new
            let data = UIImagePNGRepresentation(todoCollage) {
            let path = FileManager.documentsDir
            let fileNmae = self.taskName.text! + UUID().uuidString + ".png"
            let momoImageUrl = path.appendingPathComponent(fileNmae)
            
            try? data.write(to: momoImageUrl)
            
            return fileNmae
        }
        return self.todoItem.pictureMemoFilename // old file
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeImages()
        setupView()
    }
    
    private func setupView() {
        
        taskName.becomeFirstResponder()
        self.setMemoSectionHederText()
        
        if let todoItem = todoItem {
            self.taskName.text = todoItem.name
            self.isFinished.isOn = todoItem.isFinished
            
            if todoItem.pictureMemoFilename != "" {
                let url = FileManager.documentsDir.appendingPathComponent(todoItem.pictureMemoFilename)
                if let data = try? Data(contentsOf:url) {
                    self.setMemoBtnBackgroundImage(image: UIImage(data: data) ?? UIImage())
                }
            }
            doneButton.isEnabled = true
        } else {
            todoItem = TodoItem()
        }
    }
    
    private func subscribeImages() {
        images.asObservable().subscribe(onNext:
            { [weak self] imges in
                guard let `self` = self else { return }
                guard !imges.isEmpty else {
                    self.resetMemoBtn()
                    return
                }
                self.todoCollage = UIImage.collage(
                    images: imges, in: self.collageButton.frame.size)
                self.setMemoBtnBackgroundImage(
                    image: self.todoCollage ?? UIImage())
        }).disposed(by: bag)
    }
    
    fileprivate func resetMemoBtn() {
        collageButton.setBackgroundImage(nil, for: .normal)
        collageButton.setTitle("Tap here to add your picture memos", for:.normal)
    }
    
    fileprivate func setMemoBtnBackgroundImage(image: UIImage) {
        collageButton.setBackgroundImage(image, for: .normal)
        collageButton.setTitle("", for: .normal)
    }
}


extension TodoDetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let photosController = segue.destination as! PhotoCollectionViewController
        images.value.removeAll()
        resetMemoBtn()
        
        let selectedPhotos = photosController.selectedPhotos.share()
        _ = selectedPhotos.scan([]){(photos: [UIImage], newPhoto: UIImage) in
            var newPhotos = photos
            if let index = newPhotos.index(where: {
               UIImage.isEqual(lhs: newPhoto, rhs: $0)
            }) { // remove the duplicate photo
                newPhotos.remove(at: index)
            }
            else { // add the new photo
                newPhotos.append(newPhoto)
            }
            return newPhotos
            }.subscribe(onNext: { (photos: [UIImage]) in
                self.images.value = photos
        },onDisposed: {
                print("Finished choose photo memos.")
        })
        
        _ = selectedPhotos.ignoreElements()
            .subscribe(onCompleted: {
                self.setMemoSectionHederText()
            })
    }
}


extension TodoDetailViewController {
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func setMemoSectionHederText() {
        guard !images.value.isEmpty,
            let headerView = self.tableView.headerView(forSection: 2) else { return }
        
        headerView.textLabel?.text = "\(images.value.count) MEMOS"
    }}

extension TodoDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneButton.isEnabled = newText.length > 0
        
        return true
    }
}

//
//  TodoDetailViewController.swift
//  TodoApp
//
//  Created by Owner on 2020/06/15.
//  Copyright © 2020 Owner. All rights reserved.
//
import UIKit

import RealmSwift

class TodoDetailViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var commitButton: UIButton!

    

    var actionType = ""
    var selectedTodo = Todo()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
    }


    func initView(){
        
        if actionType == "NEW" {
            self.title = "TODO新規追加"
            self.commitButton.setTitle("新規追加", for: .normal)
            self.commitButton.addTarget(self, action: #selector(self.dbAdd), for: .touchUpInside)
            self.titleField.text = ""
            self.descTextView.text = ""
            self.navigationItem.rightBarButtonItem = nil
        } else if actionType == "UPDATE" {
            self.title = "TODO編集"
            self.commitButton.setTitle("更新", for: .normal)
            self.commitButton.addTarget(self, action: #selector(self.dbUpdate), for: .touchUpInside)
            self.titleField.text = selectedTodo.name
            self.descTextView.text = selectedTodo.desc
        }
    }


    @objc func dbAdd(sender: AnyObject?){
        print("追加")
        if isValidateInputContents() == false{
            return
        }
        print("1asdfa")

        let toDo = Todo()
        
        toDo.name = titleField.text!
        print(toDo.name)

        toDo.createDate = NSDate()
        print(toDo.createDate)
        print()
        do{
            let realm = try! Realm()
            try realm.write{
                realm.add(toDo)
            }
            print("DB登録成功")
        }catch{
            print("DB登録失敗")
        }

        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dbUpdate(sender: AnyObject?){
        do{
            let realm = try Realm()
            try realm.write{
                selectedTodo.name = self.titleField.text!
                selectedTodo.desc = self.descTextView.text
                selectedTodo.updateDate = NSDate()
            }
            print("DB更新成功")
        }catch{
            print("DB更新失敗")
        }
     
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dbDelete(sender: AnyObject) {
        print("消去")
        do{
            let realm = try Realm()
            try realm.write{
                realm.delete(selectedTodo)
            }
        }catch{
            print("失敗")
        }
        self.navigationController?.popViewController(animated: true)
       
    }

    

    private func isValidateInputContents() -> Bool{
    
        if let title = titleField.text{
            if title.count == 0{
                return false
            }
        }else{
            return false
        }
        return true
    }

}

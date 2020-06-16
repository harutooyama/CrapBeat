//
//  ViewController.swift
//  TodoApp
//
//  Created by Owner on 2020/06/15.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var todoItems:Results<Todo>?{
        do{
            let realm = try! Realm()
            //print(Realm.Configuration.defaultConfiguration.fileURL!)
            print(realm.objects(Todo.self))
            return realm.objects(Todo.self)
        }catch{
            print("エラー")
        }
        return nil
    }
    
    var actionType = ""
    var selectedTodo:Todo!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let toDo = todoItems?[indexPath.row]
        cell.textLabel?.text = toDo?.name
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBAction func addButtonTapped(sender: AnyObject) {

        self.actionType = "NEW"
        self.performSegue(withIdentifier: "toDetail", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "toDetail" {
            let vc = segue.destination as! TodoDetailViewController
            vc.actionType = self.actionType
            //vc.selectedTodo = selectedTodo!
        }
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        self.actionType = "UPDATE"
        selectedTodo = todoItems?[indexPath.row]
        self.performSegue(withIdentifier: "toDetail", sender: selectedTodo)
    }

    


 
}


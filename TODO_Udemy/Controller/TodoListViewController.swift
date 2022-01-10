//
//  ViewController.swift
//  TODO_Udemy
//
//  Created by Oluwayomi M on 2022-01-08.
//

import UIKit

class TodoListViewController: UITableViewController {

    let defualts = UserDefaults.standard
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newItem = Item()
        newItem.title  = "Fine Mike"
        
        itemArray.append(newItem)
//        if let items = defualts.array(forKey: "TodoListArray") as? [String]{
//            itemArray = items
//        }
       
        // Do any additional setup after loading the view.
    }
     //MARK: - Tableview datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title

        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
     //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        //Add Checkmarkt
//
//        if itemArray[indexPath.row].done == false{
//            itemArray[indexPath.row].done = true
//        }else {
//            itemArray[indexPath.row].done = false
//        }
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
     //MARK: - Add New Item
    
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            // What happens when the user click on the add button
            if textfield.text != "" {
                
                let newItem = Item()
                newItem.title = textfield.text!
                self.itemArray.append(newItem)
                
                //Save Array With UserDefault
                self.defualts.set(self.itemArray, forKey: "TodoListArray")
                
                //Reload Table View
                self.tableView.reloadData()
                
            }else{
                
                
                //MARK: -Error Handler
                // create the alert
                       let alert = UIAlertController(title: "Error", message: "Todo Text Field Cannot Be Empty", preferredStyle: UIAlertController.Style.alert)

                       // add an action (button)
                       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                       // show the alert
                       self.present(alert, animated: true, completion: nil)
            }
        }
        
        //Alert Textfield
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textfield = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}


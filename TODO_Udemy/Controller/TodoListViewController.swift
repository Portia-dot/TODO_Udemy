//
//  ViewController.swift
//  TODO_Udemy
//
//  Created by Oluwayomi M on 2022-01-08.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController {

    let defualts = UserDefaults.standard
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
//        if let items = defualts.array(forKey: "TodoListArray") as? [String]{
//            itemArray = items
//        }
        loadItems()
        // Do any additional setup after loading the view.
    }
    
  
    @IBOutlet weak var searchBar: UISearchBar!
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
        
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
     //MARK: - Add New Item
    
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            // What happens when the user click on the add button
            if textfield.text != "" {
                
                
                let newItem = Item(context: self.context)
                newItem.title = textfield.text!
                
                //set the done for all item
                newItem.done = false
                
                self.itemArray.append(newItem)
                
                //Save Array With UserDefault
                self.saveItems()
                
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
    
    //MARK: - Model Manupulation Methods

   func saveItems(){
       
       
       do{
         try context.save()
       }catch {
           print( "Error saving context \(error)")
       }
       //Reload Table View
       tableView.reloadData()
   }

     //MARK: - Load Items
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error Fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
}

 //MARK: - Extension Search Bar Methods
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@",searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

//        do{
//            itemArray = try context.fetch(request)
//        }catch{
//            print("Error Fetching data from context \(error)")
//        }
        loadItems(with: request)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

 

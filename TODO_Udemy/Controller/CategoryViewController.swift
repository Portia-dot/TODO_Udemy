//
//  CategoryViewController.swift
//  TODO_Udemy
//
//  Created by Oluwayomi M on 2022-01-16.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [CategoryList]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell//MARK: - TableView DataSource Methods
        
        //MARK: - TableView Delegate Methods
    }
   
    //MARK: - TableView Delegate Methods
    
    //
    
    
    func saveCategories(){
        do{
            try context.save()
        }catch{
            print("Error Saving Category \(error)")
        }
        tableView.reloadData()
        
       
    }
    
    func loadCategories(){
        let request : NSFetchRequest<CategoryList> = CategoryList.fetchRequest()
        do{
       categories = try context.fetch(request)
        }catch{
            print("There was an error loading category \(error)")
            tableView.reloadData()
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action  = UIAlertAction(title: "Add", style: .default) { action in
           
            let newCategory = CategoryList(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            
            self.saveCategories()
            
        }
        alert.addAction(action)
        
        alert.addTextField { field in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
    
     
}

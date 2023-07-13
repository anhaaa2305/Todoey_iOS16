//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by 🤪😋😝Ronaldo👻👻👻 Ánh on 01/07/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData
class CategoryTableViewController: UITableViewController {
    
    // MARK: - Global Variables
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Category Database:\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")
        loadCategory()
    }
    
    // MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        categoryCell.textLabel?.text = categoryArray[indexPath.row].name
        return categoryCell
    }
    
    // MARK: - Tableview Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.identifier.CateToItem, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    // MARK: Add Category
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            // Reload Data:
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveCategory()
        }
        // Add textfield:
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        // Add action on Screen
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
    }

    // MARK: - Data Manipulation 
    func saveCategory() {
        do {
            try context.save()
            print("Completed save Category data")
        } catch {
            print("Error saving Category data into CoreData: \(error)")
        }
        tableView.reloadData()
    }
    func loadCategory(){
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        }catch {
            print("Error fetching Category data from CoreData: \(error)")
        }
        tableView.reloadData()
    }
}

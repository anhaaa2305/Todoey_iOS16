//
//  ViewController.swift
//  Todoey
import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    // MARK: - Global Variales
    let realm = try! Realm()
    var todoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadItem()
        }
    }
    //let defaults = UserDefaults.standard        // Set defaults with Standard   , we don't use UserDefaults => Comment defaults
    //let request: NSFetchRequest<Item> = Item.fetchRequest()
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // UIApplication.shared.delegate as! AppDelegate to call AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = selectedCategory?.name
        print("Item Database: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")
        loadItem()
    }
    
    // MARK: - Table DataSource Methods
    // Set dataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1  //Get the number of the List at row 9
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCell = tableView.dequeueReusableCell(withIdentifier: K.tableViewCell.identifierItemCell, for: indexPath)       // Choose the object with default identify
        if let item = todoItems?[indexPath.row] {
            itemCell.textLabel?.text = item.title
            itemCell.accessoryType = item.done ? .checkmark : .none    // Change for the line 44 to 49
        } else {
            itemCell.textLabel?.text  = "No Item added yet"
        }
        return itemCell
    }
    
    // MARK: - Table View Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row]) // get text
        //todoItems[indexPath.row].done = !todoItems?[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        // Delete Item:
        /*
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
         */
    }
    
    // MARK: - Add Items Button:
    @IBAction func addItemButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: K.alertTitle, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: K.actionTitle, style: .default) { (action) in
            // Reload Data
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving data into Realm \(error)")
                }
            }
            self.tableView.reloadData()
        }
        // Add textField
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        // Add action on the Screen
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    // MARK: Refresh button
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        
    }
    // MARK: CRUD Data
    // Create Data into Todoey_Item.plist
    // Read Data from Todoey_Item.plist        // LoadITem
    func loadItem() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title",ascending: true)
        tableView.reloadData()
    }
}
extension ToDoListViewController: UISearchBarDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate {
    // MARK: Setting for Search bar setting
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        /*
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
        loadItem(with: request, predicate: predicate)
         */
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        /*
        if searchBar.text?.count == 0 {
            loadItem()
        }
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
         */
    }
}


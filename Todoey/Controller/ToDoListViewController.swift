//
//  ViewController.swift
//  Todoey
import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    // MARK: - Global Variales
    let realm = try! Realm()
    var toDoItems: Results<Item>?
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
        navigationItem.title = selectedCategory?.name          // Set navigation title with Category
        print("Item Database: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")  // Print the file Path
        loadItem()           // Load Item
    }
    
    // MARK: - Table DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1  //Get the number of the List at row 9
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCell = tableView.dequeueReusableCell(withIdentifier: K.tableViewCell.identifierItemCell, for: indexPath)       // Choose the object with default identify
        
        // Unwrap toDoItems
        if let item = toDoItems?[indexPath.row] {
            itemCell.textLabel?.text = item.title         // Set the text in the cell equal title of item
            itemCell.accessoryType = item.done ? .checkmark : .none        // Set the type of the AccessoryType
        } else {
            itemCell.textLabel?.text  = "No Item added yet"
        }
        return itemCell
    }
    
    // MARK: - Table View Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Create model Updating data in Realm
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    if item.done == true {
                        realm.delete(item)
                    } else {
                        item.done = !item.done     // Check done Properties
                    }
                }
            } catch {
                print("Error updating data Status \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
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
                        newItem.dateCreated = Date()
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
        loadItem()
    }
    // MARK: CRUD Data
    // Read Data from Todoey_Item.plist        // LoadITem
    func loadItem() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title",ascending: true)
        tableView.reloadData()
    }
}
extension ToDoListViewController: UISearchBarDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate {
    // MARK: Setting for Search bar setting
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated",ascending: true)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


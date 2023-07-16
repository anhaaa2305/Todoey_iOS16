//
//  ViewController.swift
//  Todoey
import UIKit
import RealmSwift
import SwipeCellKit

class ToDoListViewController: SwipeViewController {
    // MARK: - Global Variales
    let realm = try! Realm()
    var toDoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadItem()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = selectedCategory?.name          // Set navigation title with Category
        print("Item Database: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")  // Print the file Path
        tableView.rowHeight = 80
        loadItem()
    }
    // MARK: - Table DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1  //Get the number of the List at row 9
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCell = super.tableView(tableView, cellForRowAt: indexPath)      // Choose the object with default identify
        // Unwrap toDoItems
        if let item = toDoItems?[indexPath.row] {
            itemCell.textLabel?.text = item.title         // Set the text in the cell equal title of item
            /*
               Ternary operator =>
             Value = Condition ? valueIfTrue : valueIfFalse
             */
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
                    item.done = !item.done     // Check done Properties
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
    // MARK: Thông báo xoá lỗi
    func showSimpleAlert() {
           // Khởi tạo UIAlertController
           let alertController = UIAlertController(title: "Item chưa được hoàn thành", message: "Nếu bạn vẫn muốn xoá, vui lòng ấn nút đóng ", preferredStyle: .alert)
           // Khởi tạo hành động cho thông báo
           let action = UIAlertAction(title: "Đóng", style: .default) { (_) in
               // Hành động khi người dùng chọn "Đóng"
               self.dismiss(animated: true,completion: nil)
           }
           // Thêm hành động vào UIAlertController
           alertController.addAction(action)
           // Hiển thị UIAlertController
           self.present(alertController, animated: true, completion: nil)
            
       }
    // MARK: Back button
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    // MARK: CRUD Data
    // LoadITem
    func loadItem() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title",ascending: true)
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        if let itemForDeletion = toDoItems?[indexPath.row] {
            do {
                if itemForDeletion.done == true {
                    try self.realm.write {
                        self.realm.delete(itemForDeletion)
                    }
                } else {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error when Delete Item\(error)")
            }
        }
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


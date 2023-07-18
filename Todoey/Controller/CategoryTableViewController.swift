
import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryTableViewController: SwipeViewController {
    
    // MARK: - Global Variables
    let realm = try! Realm()
    var categories: Results<Category>?
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Category Database:\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        loadCategory()
    }
    // MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1      // If categories?.count is nil, return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = super.tableView(tableView, cellForRowAt: indexPath)
        if let categoryColor = categories?[indexPath.row] {
            categoryCell.textLabel?.text = categoryColor.name
            categoryCell.backgroundColor = UIColor(hexString: categoryColor.colour)
            categoryCell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: categoryColor.colour)!, returnFlat: true)
        }
        return categoryCell
    }
    // MARK: - Tableview Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.identifier.CateToItem, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    // MARK: Add Category
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            // Reload Data:
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
            self.saveCategory(category: newCategory)
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
    func notificationDeleted () {
        // Khởi tạo UIAlertController
        let alertController = UIAlertController(title: "Notification", message: "Completed Delete", preferredStyle: .alert)
        // Khởi tạo hành động cho thông báo
        let action = UIAlertAction(title: "Đóng", style: .default) { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }
        // Thêm hành động vào UIAlertController
        alertController.addAction(action)
        // Hiển thị UIAlertController
        self.present(alertController, animated: true, completion: nil)
        let timeForDelay = 5.0 // Thời gian đóng thông báo (đơn vị: giây)
        DispatchQueue.main.asyncAfter(deadline: .now() + timeForDelay) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    // MARK: - Data Manipulation 
    func saveCategory(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
            print("Completed save Category data")
        } catch {
            print("Error saving Category data into CoreData: \(error)")
        }
        tableView.reloadData()
    }
    func loadCategory(){
        categories = realm.objects(Category.self)      // Fetch data from Realm
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath){
        super.updateModel(at: indexPath)
        if let categoryForDeletion = categories?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                    self.notificationDeleted()
                }
            } catch {
                print("Error when delete data \(error)")
            }
        }
    }
}
// MARK: Setting for Search bar setting
extension CategoryTableViewController: UISearchBarDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        categories = categories?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name",ascending: true)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadCategory()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

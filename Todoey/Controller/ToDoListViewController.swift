//
//  ViewController.swift
//  Todoey
import UIKit
import CoreData
class ToDoListViewController: UITableViewController {
    
    // MARK: - Global Variales
    var itemArray = [Item]()
    //let defaults = UserDefaults.standard        // Set defaults with Standard   , we don't use UserDefaults => Comment defaults
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // UIApplication.shared.delegate as! AppDelegate to call AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // Do any additional setup after loading the view.
        /*
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        let newItem2 = Item()
        newItem2.title = "Buy Oggs"
        itemArray.append(newItem2)
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
         */
        /*
        if let items = defaults.array(forKey: "toDoListArray") as? [Item] {     // Call data in
            itemArray = items
        }
        */
        
        //DecoderData()
    }
    
    // MARK: - Table DataSource Methods
    // Set dataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count  //Get the number of the List at row 9
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifierItemCell, for: indexPath)       // Choose the object with default identify
        cell.textLabel?.text = itemArray[indexPath.row].title // Set text to the Cell
        
        // Set the Checkmark
        /*
        if itemArray[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        */
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none    // Change for the line 44 to 49
        return cell 
    }
  
    // MARK: - Table View Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row]) // get text
        
        /*
        if itemArray[indexPath.row].done == false {
            itemArray[indexPath.row].done = true
        } else {
            itemArray[indexPath.row].done = false
        }
        */
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done   // Change for the line 57 to 62
        tableView.reloadData()       // Reload Data in Delegate Method to DataSource
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add Items Button:
    @IBAction func addItemButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: K.alertTitle, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: K.actionTitle, style: .default) { (action) in
            // Reload Data
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.EncoderData()
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
    // MARK: Codable Data
    // Encoder Data into Todoey_Item.plist
    func EncoderData() {
        do {
            /* We don't use Encoder , because of we comments this line
            let dataEncoder = try encoder.encode(itemArray)   // Encoder data in itemArray
            try dataEncoder.write(to: dataFilePath!)         // Write to Todoey_Item.plist
             */
            try context.save()
            print("Completed save data")
        } catch {
            //print("Error encoding item array \(error)")
            print("Error saving data: \(error)")
        }
        self.tableView.reloadData()
    }
    /*
    // Decoder Data from Todoey_Item.plist
    func DecoderData() {
        if let dataDecoder = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                /* We don't use Decoder, because of we comments this line
                itemArray = try decoder.decode([Item].self, from: dataDecoder)
                 */
                
            } catch {
                //print("Error Decoding \(error)")
            }
        }
    }
     */
}

